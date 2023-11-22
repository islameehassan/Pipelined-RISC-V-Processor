`ifndef N_BIT_REGISTER
`define N_BIT_REGISTER
`include "srcs/Mux_2x1.v"
`include "srcs/DFlipFlop.v"
/*******************************************************************
*
* Module: Nbit_Register.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: clk, rst, load, d
               @outputs: q
               @importance: storing
*
* Change history: No changes on the implementation done in the lab
*
**********************************************************************/

module Nbit_Register#(parameter N = 8)(
    input clk,
    input rst,
    input load,
    input[N-1:0] d,
    output[N-1:0] q
);

    genvar i;

    wire[N-1:0] data;
    generate
        for(i = 0; i < N; i=i+1)begin
        Mux_2x1 mux(.a(d[i]), .b(q[i]), .sel(load), .out(data[i])); 
        DFlipFlop FF(clk, rst, data[i], q[i]);
        end
    endgenerate
endmodule

`endif