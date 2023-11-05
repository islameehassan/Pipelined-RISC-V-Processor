`include"srcs/DataMem.v"

/*******************************************************************
*
* Module: ControlUnit.v
* Project: Pipelined-RISC-V Processor
* Author: Adham El-Asfar, adham_samy@aucegypt.edu
* Description: @inputs: 
               @outputs:
               @importance: testing all the load and store instructions seperately from 
                            other instructions
*
* Change history: 04/11/2023 – created and added the test cases
*
**********************************************************************/

module DataMem_tb();
 
 localparam clk_period = 10;
 reg clk;
 reg MemRead;
 reg MemWrite;
 reg [2:0] func3;
 reg [31:0] addr;
 reg [31:0] data_in;
 wire [31: 0] data_out;
 
 DataMem DM(clk, MemRead, MemWrite, func3, addr, data_in, data_out);
 initial begin
 clk = 0;
 forever
    #(clk_period/2) clk = ~clk;
 end
 
 initial begin
    MemRead = 0;
    MemWrite = 1;
    func3 = 3'b010;
    addr = 0;
    data_in = 32'b00000000_00000000_00000110_11110100;
    #clk_period
    func3 = 3'b000;
    MemWrite = 0;
    MemRead = 1;
    #clk_period
    if(data_out == -12)
        $display("Success");
     else
        $display("Failure");
    #clk_period
    func3 = 3'b100;
    addr = 0;
    #clk_period
    
    if(data_out == 244)
        $display("Success");
     else
        $display("Failure");
    #clk_period
    
    MemRead = 0;
    MemWrite = 1;
    func3 = 3'b010;
    addr = 4;
    data_in = 32'b00000000_00000100_11100110_00110100;
    #clk_period
    MemWrite = 0;
    MemRead = 1;
    func3 = 3'b001;
    #clk_period
    if(data_out == -6604)
        $display("Success");
     else
        $display("Failure");
    #clk_period
    func3 = 3'b101;
    addr = 4;
    #clk_period
    if(data_out == 58932)
        $display("Success");
     else
        $display("Failure");
    #clk_period
    
    MemRead = 0;
    MemWrite = 1;
    func3 = 3'b010;
    addr = 0;
    data_in = 32'b00000011_00000001_00000110_11110100;
    #clk_period
    MemWrite = 0;
    MemRead = 1;
    #clk_period
    if(data_out == 50398964)
        $display("Success");
     else
        $display("Failure");
    #clk_period

    $finish;
 end
 
 
endmodule

