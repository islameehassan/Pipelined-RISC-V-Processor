`ifndef RCA
`define RCA
`include "srcs/FullAdder.v"

/*******************************************************************
*
* Module: Nbit_Register.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: a, b
               @outputs: sum
               @importance: ripple-carry-added adding a and b and storing in sum
*
* Change history: No changes on the implementation done in the lab
*
**********************************************************************/

module RCA #(parameter N = 8)(input [N - 1: 0] a, b, output[N: 0] sum);

    wire [N: 0] cin;
    genvar i;

    assign cin[0] = 0;
    generate
        for(i = 0; i < N; i=i+1)begin 
            FullAdder FA(a[i], b[i],cin[i], sum[i], cin[i + 1]);
        end
    endgenerate
    assign sum[N] = cin[N];
endmodule
`endif