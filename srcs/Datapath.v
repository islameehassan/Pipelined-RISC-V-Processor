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
    
    wire [31:0] PC;
    wire [31:0] instruction;                                                            // InstMem - ControlUnit - ImmGen - RegFile - RCA
    wire [31:0] RF_data1, RF_data2, RF_writedata;                                       // RegFile - ALU - DataMem
    wire [31:0] imm;                                                                    // ImmGen - Nbit_ShiftLeftBy1
    wire [31:0] ALU_data2, ALU_result;                                                  // ALU
    wire [31:0] DM_result, Mux_DM_Result;                                               // DataMem
    //wire [31:0] SL_result;                                                              // Nbit_ShiftLeftBy1 - RCA
    wire [31:0] RCA_result;                                                             // RCA
    wire [31:0] new_PC;                                                                 // Nbit_Register
    
    wire [4:0] shamt;
    wire [3:0] alusel;                                                                  // ALU_ControlUnit - ALU
    wire [2:0] aluop;                                                                   // ControlUnit - ALU_ControlUnit
    wire [1:0] regwrite_sel;                                                            // ControlUnit - ALU_ControlUnit
    wire [1:0] pcsrc;

    wire cf, zf, vf, sf, branch_flag;                                                   // ALU - BranchingUnit 
    wire branch, memread, memtoreg, memwrite, alusrc, regwrite, jal_jump, jalr_jump;    // ControlUnit - DataMem                                                                 
    wire halt;                                                                          // HaltingUnit
    
   

    
    /*
        Instruction Memory
        - Fetching instructions each positive edge
    */
    InstMem IM(.addr(PC), .data_out(instruction)); 
    
    
    
    RegFile rf(.clk(clk), .rst(rst), .regwrite(regwrite), .readreg1(instruction[`IR_rs1]), .readreg2(instruction[`IR_rs2]), .writereg(instruction[`IR_rd]), .writedata(RF_writedata), .readdata1(RF_data1), .readdata2(RF_data2));
    ControlUnit cu(.inst(instruction[`IR_opcode]), .branch(branch), .memread(memread), .memtoreg(memtoreg), .memwrite(memwrite), .alusrc(alusrc), .regwrite(regwrite), .jalr_jump(jalr_jump), .jal_jump(jal_jump), .regwrite_sel(regwrite_sel), .aluop(aluop));
    ImmGen ig(.inst(instruction), .imm(imm));    
    ALU_ControlUnit alu_c(.aluop(aluop), .func3(instruction[`IR_funct3]), .func7bit(instruction[30]), .alusel(alusel));
    
    /*
        ALU 
    */
    assign ALU_data2 = (alusrc)?(imm):(RF_data2);
    assign shamt = (instruction[5])?(RF_data2):(instruction[`IR_shamt]);
    ALU alu(.a(RF_data1), .b(ALU_data2), .shamt(shamt), .alusel(alusel), .r(ALU_result), .cf(cf), .zf(zf), .vf(vf), .sf(sf));
    
    /*
        Data Memory
        --> regwrite_sel: RF_writedata
        --> 00: write from the mux after the data memory, which selects from the alu output or the data memory output
        --> 01: write from PC + 4, which is the case in jal and jalr instructions
        --> 10: write from imm, which is the case in LUI
        --> 11: write from the rca, which is the case in AUIPC
    */
    DataMem dm(.clk(clk), .memread(memread), .memwrite(memwrite), .func3(instruction[`IR_funct3]), .addr(ALU_result), .data_in(RF_data2), .data_out(DM_result));
    assign Mux_DM_Result = (memtoreg)?(DM_result):(ALU_result);
    assign RF_writedata = (regwrite_sel[1] == 1'b0) ? (regwrite_sel[0] == 1'b0 ? Mux_DM_Result: PC + 4): (regwrite_sel[0] == 1'b0 ? imm:RCA_result);  

    /*
        PC Manipulation
        --> PCSRC:  new_PC
        --> 00: Takes the value of PC+4 which means there is no branching or jumping
        --> 01: Takes the value of PC which means it is an ebreak instruciton to stop the code
        --> 10: Takes the value coming from the RCA after branching or jumping
        --> 11: Takes the value coming from the ALU after JALR instruction
    */
    BranchingUnit bu(.func3(instruction[`IR_funct3]), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .jalr_jump(jalr_jump), .r(branch_flag));
    HaltingUnit hu(.inst(instruction[`IR_opcode]), .ebreak_bit(instruction[20]), .halt(halt));
    
    assign pcsrc = {(branch & branch_flag) | jal_jump, jalr_jump | halt};
    //Nbit_ShiftLeftBy1 #(32) sl(.a(imm), .b(SL_result));           // No need
    RCA #(32) rca(.a(PC), .b(imm), .sum(RCA_result));
    assign new_PC = (pcsrc[1] == 1'b0) ? (pcsrc[0] == 1'b0 ? PC+4: PC): (pcsrc[0] == 1'b0 ? RCA_result: ALU_result);    Nbit_Register #(32)pc(clk, rst, 1, new_PC, PC);
    

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
        4'b1000: ssd = imm; // "8"                  // Was SL_Result
        4'b1001: ssd = ALU_data2; // "9"
        4'b1010: ssd = ALU_result; // "negative"
        4'b1011: ssd = DM_result; // "off"
        default: ssd = 12'b0; // "0"
       endcase 
    end
    
endmodule