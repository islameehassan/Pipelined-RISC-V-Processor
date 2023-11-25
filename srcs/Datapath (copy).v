// `ifndef DATAPATH
// `define DATAPATH
// `include "include/defines.v"
// `include "srcs/InstMem.v"
// `include "srcs/RegFile.v"
// `include "srcs/ControlUnit.v"
// `include "srcs/ImmGen.v"
// `include "srcs/ALU_ControlUnit.v"
// `include "srcs/ALU.v"
// `include "srcs/DataMem.v"
// `include "srcs/RCA.v"
// `include "srcs/Nbit_Register.v"
// `include "srcs/Nbit_mux4to1.v"
// `include "srcs/Mux_2x1.v"
// `include "srcs/DFlipFlop.v"
// `include "srcs/ForwardingUnit.v"
// `include "srcs/BranchingUnit.v"
// `include "srcs/HaltingUnit.v"
// `include "srcs/HazardUnit.v"
// `include "srcs/Nbit_Register.v"
// `include "srcs/slowclk.v"

`include "defines.v"

/*******************************************************************
*
* Module: Datapath.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: clk, rst, ledSel, ssdSel
               @outputs: leds, ssd
               @importance: module connecting all other components
*
* Change history: 03/11/2023 – added the branching and halting units
                  04/11/2023 - corrected some errors and connected all components
*
**********************************************************************/



/*
    - ALU no longer needs to output flags, just use them inside for sltu and slt
    - No need to pass alu flags to EX_MEM
    - No need to pass EX_MEM_Branch
    - No need to pass jalr_jump to the branching unit
*/
module Datapath(
    input clk,
    input rst,
    input [1:0] ledSel,
    input [3:0] ssdSel,
    output reg [15:0] leds,
    output reg [12:0] ssd
 );
    
    wire [31:0] PC;
    reg [31:0] instruction;                                                            // InstMem - ControlUnit - ImmGen - RegFile - RCA
    wire [31:0] RF_data1, RF_data2, RF_writedata;                                       // RegFile - ALU - DataMem
    wire [31:0] imm;                                                                    // ImmGen - Nbit_ShiftLeftBy1
    wire [31:0] ALU_data1, ALU_data2, Forward_MUX_data2, ALU_result;                    // ALU
    wire [31:0] Mux_DM_Result;                                                          // DataMem
    reg [31:0] DM_result;
    wire [31:0] RCA_result;                                                             // RCA
    wire [31:0] new_PC;                                                                 // Nbit_Register
    wire [31:0]comparator_first_input, comparator_second_input;
    
    wire [4:0] shamt;
    wire [4:0] alusel;                                                                  // ALU_ControlUnit - ALU
    wire [2:0] aluop;                                                                   // ControlUnit - ALU_ControlUnit
    wire [1:0] regwrite_sel;                                                            // ControlUnit - ALU_ControlUnit
    wire [9:0] control_signals;                                                        // ControlUnit
    wire PCsrc;

    wire cf, zf, vf, sf, branch_flag;                                                   // ALU - BranchingUnit 
    wire [3:0] ALU_flags;                                                               // ALU - BranchingUnit 
    wire branch, memread, memtoreg, memwrite, alusrc, regwrite, jal_jump, jalr_jump;    // ControlUnit - DataMem                                                                 
    wire halt;                                                                          // HaltingUnit
    wire stall;                                                                         // HazardUnit
    wire [1:0] forwardA, forwardB;                                                      // ForwardingUnit (2 bits is enough for both since there is no longer a EX hazard)
    wire forward_branchA, forward_branchB;

   
    
    // IF_ID Register
    
    wire [31:0] IF_ID_PC, IF_ID_Inst;
    // InstMem im(.addr(PC), .data_out(temp_instruction)); 

    // halting happens as soon as the instruction is fetched so that no other instructions are fetched after
    HaltingUnit hau(.inst(instruction[`IR_opcode]), .ebreak_bit(instruction[20]), .halt(halt));
    Nbit_Register #(32)pc(clk, rst, !halt & !stall, new_PC, PC);
    Nbit_Register #(64) IF_ID (.clk(~clk), .rst(rst), .load(!stall), .d({PC, instruction}), .q({IF_ID_PC, IF_ID_Inst}));
    
    
    // ID_EX Register
    HazardUnit hu(.IF_ID_Rs1(IF_ID_Inst[`IR_rs1]), .IF_ID_Rs2(IF_ID_Inst[`IR_rs2]), .ID_EX_Rd(ID_EX_Rd),
                  .ID_EX_MemRead(ID_EX_Ctrl_MEM[3]), .stall(stall));
    ControlUnit cu(.opcode(IF_ID_Inst[`IR_opcode]), .branch(branch), .memread(memread), .memtoreg(memtoreg), .memwrite(memwrite),
                   .alusrc(alusrc), .regwrite(regwrite), .jalr_jump(jalr_jump), .jal_jump(jal_jump), .regwrite_sel(regwrite_sel), .aluop(aluop));
    RegFile rf(.clk(~clk), .rst(rst), .regwrite(MEM_WB_Ctrl[2]), .readreg1(IF_ID_Inst[`IR_rs1]), .readreg2(IF_ID_Inst[`IR_rs2]),
               .writereg(MEM_WB_Rd), .writedata(RF_writedata), .readdata1(RF_data1), .readdata2(RF_data2));
    ImmGen ig(.inst(IF_ID_Inst), .imm(imm));

    // deciding whether to take the branch or not
    assign comparator_first_input = (forward_branchA) ? EX_MEM_ALU_out: RF_data1;
    assign comparator_second_input = (forward_branchB) ? EX_MEM_ALU_out: RF_data2;
    Comparator cmp(.a(comparator_first_input), .b(comparator_second_input), .cf(cf), .zf(zf), .vf(vf), .sf(sf));
    
    BranchingUnit bu(.func3(IF_ID_Inst[`IR_funct3]), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .r(branch_flag));

    /*
        PC Manipulation
        --> PCsrc:  new_PC
        --> 0: Takes the value of PC+4
        --> 1: Takes the value coming from the RCA after branching or jumping(jal or jalr)
    */
    assign PCsrc = {(branch & branch_flag) | jal_jump | jalr_jump};

    wire [31:0] jumping_first_input;
    assign jumping_first_input = (jalr_jump) ? RF_data1: IF_ID_PC;
    RCA #(32) rca(.a(jumping_first_input), .b(imm), .sum(RCA_result));
    assign new_PC = (PCsrc) ? RCA_result: PC+4;

    assign control_signals = {alusrc, aluop, memread, memwrite, memtoreg, regwrite, regwrite_sel};   
    assign shamt = (IF_ID_Inst[5])?(RF_data2):(IF_ID_Inst[`IR_shamt]);


    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_AUIPC_Result;
    wire [6:0] ID_EX_Func7;
    wire [3:0] ID_EX_Ctrl_EX;
    wire [1:0] ID_EX_Ctrl_MEM;
    wire [3:0] ID_EX_Ctrl_WB; 
    wire [2:0] ID_EX_Func3;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, ID_EX_OPCODE;
    wire [4:0] ID_EX_Shamt; 

    Nbit_Register #(205) ID_EX (.clk(clk), .rst(rst), .load(1'b1),
    .d({control_signals, IF_ID_PC , RF_data1, RF_data2, imm, RCA_result, IF_ID_Inst[`IR_funct7], IF_ID_Inst[`IR_funct3], 
    IF_ID_Inst[`IR_rs1], IF_ID_Inst[`IR_rs2], IF_ID_Inst[`IR_rd], shamt}),
    .q({ID_EX_Ctrl_EX, ID_EX_Ctrl_MEM, ID_EX_Ctrl_WB, ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_AUIPC_Result, ID_EX_Func7, ID_EX_Func3, ID_EX_Rs1,
     ID_EX_Rs2, ID_EX_Rd, ID_EX_Shamt}));
    


    // EX_MEM
    ForwardingUnit fu(.ID_EX_Rs1(ID_EX_Rs1), .ID_EX_Rs2(ID_EX_Rs2), .EX_MEM_Rd(EX_MEM_Rd), .MEM_WB_Rd(MEM_WB_Rd), .inst_rs1(IF_ID_Inst[`IR_rs1], .inst_rs2(IF_ID_Inst[`IR_rs2])),
    .EX_MEM_regwrite(EX_MEM_Ctrl_WB[2]), .MEM_WB_regwrite(MEM_WB_Ctrl[2]), .forwardA(forwardA), .forwardB(forwardB), .forward_branchA(forward_branchA), .forward_branchB(forward_branchB));
    ALU_ControlUnit alu_c(.opcode(ID_EX_OPCODE), .aluop(ID_EX_Ctrl_EX[2:0]), .func3(ID_EX_Func3), .func7(ID_EX_Func7), .alusel(alusel));

    Nbit_mux4to1 #(32) alu_firstinput_mux(.a(32'b0), .b(EX_MEM_ALU_out), .c(RF_writedata), .d(ID_EX_RegR1), .sel(forwardA), .q(ALU_data1));
    Nbit_mux4to1 #(32) forward_mux_aludata2(.a(32'b0), .b(EX_MEM_ALU_out), .c(RF_writedata), .d(ID_EX_RegR2), .sel(forwardB), .q(Forward_MUX_data2));
    assign ALU_data2 = (ID_EX_Ctrl_EX[3])?(ID_EX_Imm):(Forward_MUX_data2);

    ALU alu(.a(ALU_data1), .b(ALU_data2), .shamt(ID_EX_Shamt), .alusel(alusel), .r(ALU_result));

    wire [31:0] EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_PC, EX_MEM_LUI_IMM, EX_MEM_AUIPC_Result; 
    wire [1:0] EX_MEM_Ctrl_MEM;
    wire [3:0] EX_MEM_Ctrl_WB;
    wire [4:0] EX_MEM_Rd; 
    wire [2:0] EX_MEM_Func3;
                                 
    Nbit_Register #(174) EX_MEM (.clk(~clk), .rst(rst), .load(1'b1),
    .d({ID_EX_Ctrl_MEM, ID_EX_Ctrl_WB, ALU_result, Forward_MUX_data2, ID_EX_PC, ID_EX_Imm, ID_EX_AUIPC_Result, ID_EX_Rd, ID_EX_Func3}),
    .q({EX_MEM_Ctrl_MEM, EX_MEM_Ctrl_WB, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_PC, EX_MEM_LUI_IMM, EX_MEM_AUIPC_Result, EX_MEM_Rd, EX_MEM_Func3}));
    

    // MEM_WB


    // Memory
    wire [2:0] Memory_funct3;
    wire Memory_memread, Memory_memwrite;
    wire [31:0] Memory_addr, Memory_output;
    
    assign Memory_funct3 = (clk) ? (`F3_LW_SW):(EX_MEM_Func3);  // read entire word in case of reading an instruction
    assign Memory_memread = (clk) ? (1'b1):(EX_MEM_Ctrl_MEM[1]);
    assign Memory_memwrite = (clk) ? (1'b0):(EX_MEM_Ctrl_MEM[0]);
    assign Memory_addr = (clk) ? (PC):(EX_MEM_ALU_out);

    Memory mem(.clk(~clk), .memread(Memory_memread), .memwrite(Memory_memwrite), .func3(Memory_funct3), 
    .addr(Memory_addr), .data_in(EX_MEM_RegR2), .data_out(Memory_output));
    
    always @(*) begin
        if(clk == 1)
            instruction = Memory_output;
        else
            DM_result = Memory_output;
    end
    
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_AUIPC_Result, MEM_WB_PC, MEM_WB_LUI_IMM;
    wire [3:0] MEM_WB_Ctrl;
    wire [4:0] MEM_WB_Rd;  
    Nbit_Register #(169) MEM_WB (.clk(clk), .rst(rst), .load(1'b1),
    .d({EX_MEM_Ctrl_WB, DM_result, EX_MEM_ALU_out, EX_MEM_AUIPC_Result, EX_MEM_PC, EX_MEM_LUI_IMM, EX_MEM_Rd}),
    .q({MEM_WB_Ctrl, MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_AUIPC_Result, MEM_WB_PC, MEM_WB_LUI_IMM, MEM_WB_Rd}));
    

    // WB
    assign Mux_DM_Result = (MEM_WB_Ctrl[3])?(MEM_WB_Mem_out):(MEM_WB_ALU_out);
    /*
        --> regwrite_sel: RF_writedata
            --> 00: write from the mux after the data memory, which selects from the alu output or the data memory output
            --> 01: write from PC + 4, which is the case in jal and jalr instructions
            --> 10: write from imm, which is the case in LUI
            --> 11: write from the rca, which is the case in AUIPC
    */
    Nbit_mux4to1 #(32) rf_writedata_mux(.a(MEM_WB_AUIPC_Result), .b(MEM_WB_LUI_IMM), .c(MEM_WB_PC + 4), .d(Mux_DM_Result), .sel(MEM_WB_Ctrl[1:0]), .q(RF_writedata));    

    /*
        LEDs and Switches for FPGA display
    */
    always@(ledSel)begin
        if(ledSel == 2'b00)
            leds = instruction[15:0];
        else if(ledSel == 2'b01)
            leds = instruction[31:16];
        else if(ledSel == 2'b10) begin
            leds = {{2{1'b0}},branch, memread, memtoreg, memwrite, alusrc, regwrite, aluop, alusel, branch_flag, branch && branch_flag};
        end
        else
            leds = 16'b0;
    end
    
    always@(ssdSel)begin
        case(ssdSel)
        4'b0000: ssd = PC; // "0"
        4'b0001: ssd = PC + 4; // "1"
        4'b0010: ssd = RCA_result; // "2"
        4'b0011: ssd = new_PC; // "3"
        4'b0100: ssd = RF_data1; // "4"
        4'b0101: ssd = RF_data2; // "5"
        4'b0110: ssd = RF_writedata; // "6"
        4'b0111: ssd = imm; // "7"
        4'b1000: ssd = imm; // "8"                  // was SL_Result
        4'b1001: ssd = ALU_data2; // "9"
        4'b1010: ssd = ALU_result; // "negative"
        4'b1011: ssd = DM_result; // "off"
        default: ssd = 12'b0; // "0"
       endcase 
    end
    
endmodule
// `endif