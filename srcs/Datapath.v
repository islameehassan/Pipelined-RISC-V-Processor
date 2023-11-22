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

module Datapath(
    input clk,
    input rst,
    input [1:0] ledSel,
    input [3:0] ssdSel,
    output reg [15:0] leds,
    output reg [12:0] ssd
 );
    
    wire s_clk;
    wire [31:0] PC;
    wire [31:0] instruction, temp_instruction;                                          // InstMem - ControlUnit - ImmGen - RegFile - RCA
    wire [31:0] RF_data1, RF_data2, RF_writedata;                                       // RegFile - ALU - DataMem
    wire [31:0] imm;                                                                    // ImmGen - Nbit_ShiftLeftBy1
    wire [31:0] ALU_data1, ALU_data2, Forward_MUX_data2, ALU_result;                      // ALU
    wire [31:0] DM_result, Mux_DM_Result;                                               // DataMem
    //wire [31:0] SL_result;                                                             // Nbit_ShiftLeftBy1 - RCA
    wire [31:0] RCA_result;                                                             // RCA
    wire [31:0] new_PC;                                                                 // Nbit_Register
    
    wire [4:0] shamt;
    wire [3:0] alusel;                                                                  // ALU_ControlUnit - ALU
    wire [2:0] aluop;                                                                   // ControlUnit - ALU_ControlUnit
    wire [1:0] regwrite_sel;                                                            // ControlUnit - ALU_ControlUnit
    wire [12:0] control_signals, temp_control_signals;                                  // ControlUnit
    wire [1:0] PCsrc;

    wire cf, zf, vf, sf, branch_flag;                                                   // ALU - BranchingUnit 
    wire [3:0] ALU_flags;                                                               // ALU - BranchingUnit 
    wire branch, memread, memtoreg, memwrite, alusrc, regwrite, jal_jump, jalr_jump;    // ControlUnit - DataMem                                                                 
    wire halt;                                                                          // HaltingUnit
    wire stall;                                                                         // HazardUnit
    wire [1:0] forwardA, forwardB;                                                      // ForwardingUnit
    
   

    slow_clk sck(.clk(clk), .rst(rst), .slow_clk(s_clk));

    // IF_ID Register
    wire [31:0] IF_ID_PC, IF_ID_Inst;
    InstMem im(.addr(PC), .data_out(temp_instruction)); 
    assign instruction = (PCsrc == 2'b10 || PCsrc == 2'b01) ? (`NOP):(temp_instruction);   // flushing the pipeline

    // halting happens as soon as the instruction is fetched so that no other instructions are fetched after
    HaltingUnit hau(.inst(instruction[`IR_opcode]), .ebreak_bit(instruction[20]), .halt(halt));
    Nbit_Register #(64) IF_ID (.clk(clk), .rst(rst), .load(!stall), .d({PC, instruction}), .q({IF_ID_PC, IF_ID_Inst}));
    
    
    // ID_EX Register
    HazardUnit hu(.IF_ID_Rs1(IF_ID_Inst[`IR_rs1]), .IF_ID_Rs2(IF_ID_Inst[`IR_rs2]), .ID_EX_Rd(ID_EX_Rd),
                  .ID_EX_MemRead(ID_EX_Ctrl_MEM[3]), .stall(stall));
    ControlUnit cu(.inst(IF_ID_Inst[`IR_opcode]), .branch(branch), .memread(memread), .memtoreg(memtoreg), .memwrite(memwrite),
                   .alusrc(alusrc), .regwrite(regwrite), .jalr_jump(jalr_jump), .jal_jump(jal_jump), .regwrite_sel(regwrite_sel), .aluop(aluop));
    RegFile rf(.clk(clk), .rst(rst), .regwrite(MEM_WB_Ctrl[2]), .readreg1(IF_ID_Inst[`IR_rs1]), .readreg2(IF_ID_Inst[`IR_rs2]),
               .writereg(MEM_WB_Rd), .writedata(RF_writedata), .readdata1(RF_data1), .readdata2(RF_data2));
    ImmGen ig(.inst(IF_ID_Inst), .imm(imm));

    assign temp_control_signals = {alusrc, aluop, branch, memread, memwrite, jalr_jump, jal_jump, memtoreg, regwrite, regwrite_sel};    
    assign control_signals = (stall || (PCsrc == 2'b10 || PCsrc == 2'b01)) ? (12'b0): temp_control_signals;    // flushing the pipeling
    assign shamt = (IF_ID_Inst[5])?(RF_data2):(IF_ID_Inst[`IR_shamt]);


    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm; 
    wire [3:0] ID_EX_Ctrl_EX;
    wire [4:0] ID_EX_Ctrl_MEM;
    wire [3:0] ID_EX_Ctrl_WB; 
    wire [3:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    wire [4:0] ID_EX_Shamt; 

    Nbit_Register #(165) ID_EX (.clk(clk), .rst(rst), .load(1'b1),
    .d({control_signals,IF_ID_PC , RF_data1, RF_data2, imm, {IF_ID_Inst[30], IF_ID_Inst[`IR_funct3]}, 
    IF_ID_Inst[`IR_rs1], IF_ID_Inst[`IR_rs2], IF_ID_Inst[`IR_rd], shamt}),
    .q({ID_EX_Ctrl_EX, ID_EX_Ctrl_MEM, ID_EX_Ctrl_WB, ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_Func, ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, ID_EX_Shamt}));
    


    // EX_MEM
    ForwardingUnit fu(.ID_EX_Rs1(ID_EX_Rs1), .ID_EX_Rs2(ID_EX_Rs2), .EX_MEM_Rd(EX_MEM_Rd), .MEM_WB_Rd(MEM_WB_Rd), 
    .EX_MEM_regwrite(EX_MEM_Ctrl_WB[2]), .MEM_WB_regwrite(MEM_WB_Ctrl[2]), .forwardA(forwardA), .forwardB(forwardB));
    ALU_ControlUnit alu_c(.aluop(ID_EX_Ctrl_EX[2:0]), .func3(ID_EX_Func[2:0]), .func7bit(ID_EX_Func[3]), .alusel(alusel));

    Nbit_mux4to1 #(32) alu_firstinput_mux(.a(32'b0), .b(EX_MEM_ALU_out), .c(RF_writedata), .d(ID_EX_RegR1), .sel(forwardA), .q(ALU_data1));
    Nbit_mux4to1 #(32) forward_mux_aludata2(.a(32'b0), .b(EX_MEM_ALU_out), .c(RF_writedata), .d(ID_EX_RegR2), .sel(forwardB), .q(Forward_MUX_data2));
    assign ALU_data2 = (ID_EX_Ctrl_EX[3])?(ID_EX_Imm):(Forward_MUX_data2);

    ALU alu(.a(ALU_data1), .b(ALU_data2), .shamt(ID_EX_Shamt), .alusel(alusel), .r(ALU_result), .cf(cf), .zf(zf), .vf(vf), .sf(sf));
    RCA #(32) rca(.a(ID_EX_PC), .b(ID_EX_Imm), .sum(RCA_result));


    // fLUSHING
    wire [3:0] temp_ALU_flags;
    assign temp_ALU_flags = {cf, zf, vf, sf};
    assign ALU_flags = (PCsrc == 2'b10 || PCsrc == 2'b01)?(4'b0):(temp_ALU_flags);   // flushing the pipeline

    wire [8:0] temp_ctrl_signals;
    assign temp_ctrl_signals = (PCsrc == 2'b10 || PCsrc == 2'b01)?(8'b0):({ID_EX_Ctrl_MEM, ID_EX_Ctrl_WB});  // flushing the pipeline

    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_PC, EX_MEM_LUI_IMM; 
    wire [4:0] EX_MEM_Ctrl_MEM;
    wire [3:0] EX_MEM_Ctrl_WB;
    wire [4:0] EX_MEM_Rd; 
    wire [3:0] EX_MEM_ALU_Flags;
    wire [2:0] EX_MEM_Func3;
                                 
    Nbit_Register #(181) EX_MEM (.clk(clk), .rst(rst), .load(1'b1),
    .d({temp_ctrl_signals[8:4], temp_ctrl_signals[3:0], RCA_result, ALU_flags, ALU_result, Forward_MUX_data2, ID_EX_PC, ID_EX_Imm, ID_EX_Rd, ID_EX_Func[2:0]}),
    .q({EX_MEM_Ctrl_MEM, EX_MEM_Ctrl_WB, EX_MEM_BranchAddOut, EX_MEM_ALU_Flags, 
        EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_PC, EX_MEM_LUI_IMM, EX_MEM_Rd, EX_MEM_Func3}));
    

    // MEM_WB
    DataMem dm(.clk(clk), .memread(EX_MEM_Ctrl_MEM[3]), .memwrite(EX_MEM_Ctrl_MEM[2]), .func3(EX_MEM_Func3), .addr(EX_MEM_ALU_out), .data_in(EX_MEM_RegR2), .data_out(DM_result));
    BranchingUnit bu(.func3(EX_MEM_Func3), .cf(EX_MEM_ALU_Flags[3]), .zf(EX_MEM_ALU_Flags[2]), .vf(EX_MEM_ALU_Flags[1]), .sf(EX_MEM_ALU_Flags[0]),
                     .jalr_jump(EX_MEM_Ctrl_MEM[1]), .r(branch_flag));
    
    /*
        PC Manipulation
        --> PCSRC:  new_PC
        --> 00: Takes the value of PC+4
        --> 01: Takes the value coming from the RCA after branching or jumping
        --> 10: Takes the value coming from the ALU after JALR instruction
    */
    assign PCsrc = {EX_MEM_Ctrl_MEM[1], (EX_MEM_Ctrl_MEM[4] & branch_flag) | EX_MEM_Ctrl_MEM[0]};
    // assign new_PC = (PCsrc[1] == 1'b0) ? (PCsrc[0] == 1'b0 ? PC+4: PC): (PCsrc[0] == 1'b0 ? RCA_result: ALU_result); 
    Nbit_mux4to1 #(32) new_pc_mux(.a(PC), .b(EX_MEM_ALU_out), .c(EX_MEM_BranchAddOut), .d(PC+4), .sel(PCsrc), .q(new_PC));
    Nbit_Register #(32)pc(clk, rst, !halt & !stall, new_PC, PC);

    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_AUIPC_Result, MEM_WB_PC, MEM_WB_LUI_IMM;
    wire [3:0] MEM_WB_Ctrl;
    wire [4:0] MEM_WB_Rd;  
    Nbit_Register #(169) MEM_WB (.clk(clk), .rst(rst), .load(1'b1),
    .d({EX_MEM_Ctrl_WB, DM_result, EX_MEM_ALU_out, EX_MEM_BranchAddOut, EX_MEM_PC, EX_MEM_LUI_IMM, EX_MEM_Rd}),
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