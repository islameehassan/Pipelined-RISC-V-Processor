`include "include/defines.v"

module Datapath(
    input clk,
    input rst,
    input [1:0] ledSel,
    input [3:0] ssdSel,
    output reg [15:0] leds,
    output reg [12:0] ssd
    );
    wire [31:0] PC;
    wire [31:0] instruction;                                        // InstMem - ControlUnit - ImmGen - RegFile - RCA
    wire [31:0] RF_data1, RF_data2, RF_writedata;                   // RegFile - ALU - DataMem
    wire branch, memread, memtoreg, memwrite, alusrc, regwrite;     // ControlUnit - DataMem
    wire [1:0] aluop;                                               // ControlUnit - ALU_ControlUnit
    wire [31:0] gen_out;                                            // ImmGen - Nbit_ShiftLeftBy1
    wire [3:0] alusel;                                              // ALU_ControlUnit - ALU
    wire [31:0] ALU_data2;                                          // ALU
    wire [31:0] ALU_result;                                         // ALU - DataMem
    wire ZeroFlag;                                                  // ALU
    wire [31:0] DM_result;                                          // DataMem
    wire [31:0] SL_result;                                          // Nbit_ShiftLeftBy1 - RCA
    wire [31:0] RCA_result;                                         // RCA
    wire [31:0] new_PC;                                              
    
   

    
    /*
        Instruction Memory
    */
    // Fetching instructions each positive edge
  
    
    InstMem IM(.addr(PC), .data_out(instruction)); 
    
    
    
    RegFile RF(.readreg1(instruction[19:15]), .readreg2(instruction[24:20]), .writereg(instruction[11:7]), .writedata(RF_writedata), .regwrite(regwrite), .rst(rst), .clk(clk), .readdata1(RF_data1), .readdata2(RF_data2));
    ControlUnit CU(.inst(instruction[6:2]), .branch(branch), .memread(memread), .memtoreg(memtoreg), .memwrite(memwrite), .alusrc(alusrc), .regwrite(regwrite), .aluop(aluop));
    ImmGen IG(.inst(instruction), .gen_out(gen_out));    
    ALU_ControlUnit ALU_C(.aluop(aluop), .func3(instruction[14:12]), .func7bit(instruction[30]), .alusel(alusel));
    
    /*
    ALU 
    */
    assign ALU_data2 = (alusrc)?(gen_out):(RF_data2);
    ALU alu(.A(RF_data1), .B(ALU_data2), .sel(alusel), .ALUOutput(ALU_result), .ZeroFlag(ZeroFlag));
    
    /*
    Data Memory
    */
    DataMem DM(.clk(clk), .memread(memread), .memwrite(memwrite), .addr(ALU_result[5:0]), .data_in(RF_data2), .data_out(DM_result));
    assign RF_writedata = (memtoreg)?(DM_result):(ALU_result);
    
   
    /*
    PC Manipulation
    */
    Nbit_ShiftLeftBy1 #(32) SL(.a(gen_out), .b(SL_result));
    RCA #(32) rca(.a(PC), .b(SL_result), .sum(RCA_result));
    assign new_PC = (branch && ZeroFlag)?(RCA_result):(PC+4);  
    Nbit_Register #(32)pc(clk, rst, 1, new_PC, PC);
    
    
    always@(ledSel)begin
        if(ledSel == 2'b00)
            leds = instruction[15:0];
        else if(ledSel == 2'b01)
            leds = instruction[31:16];
        else if(ledSel == 2'b10) begin
            leds[15:14] = 2'b00;
            leds = {branch, memread, memtoreg, memwrite, alusrc, regwrite, aluop, alusel, ZeroFlag, branch && ZeroFlag};
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
        4'b0111: ssd = gen_out; // "7"
        4'b1000: ssd = SL_result; // "8"
        4'b1001: ssd = ALU_data2; // "9"
        4'b1010: ssd = ALU_result; // "negative"
        4'b1011: ssd = DM_result; // "off"
        default: ssd = 12'b0; // "0"
       endcase 
    end
    
endmodule