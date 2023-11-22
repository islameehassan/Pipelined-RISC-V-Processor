`include "Nbit_mux4to1.v"

/*******************************************************************
*
* Module: Datapath_tb.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: 
               @outputs:
               @importance: testing the datapath
*
* Change history: No changes were made on the lab implementation
*
**********************************************************************/
module Nbit_mux4to1_tb();

    localparam clk_period = 20;


    reg [31:0] A, B, C, D;
    reg [1:0] sel;
    output[31:0] Q;

    Nbit_mux4to1 #(32) muux (A, B, C, D, sel, Q);

    initial begin
        // $dumpfile("Nbit_mux4to1.vcd");
        // $dumpvars(0,Nbit_mux4to1_tb);
        A = 10'd5;
        B = 10'd6;
        C = 10'd7;
        D = 10'd8;
        sel = 2'b11;
        #clk_period
        if(Q == A)
            $display("Success");
        else
            $display("Failure");
        sel = 2'b10;
        #clk_period
        if(Q == B)
            $display("Success");
        else
            $display("Failure");
        sel = 2'b01;
        #clk_period
        if(Q == C)
            $display("Success");
        else
            $display("Failure");
        sel = 2'b00;
        #clk_period
        if(Q == D)
            $display("Success");
        else
            $display("Failure");
        $finish;

    end
endmodule