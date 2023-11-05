`include "Mux_2x1.v"

/*******************************************************************
*
* Module: Nbit_mux2to1.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: a, b, sel
               @outputs: q
               @importance: selecting from two n-bit inputs based on sel
*
* Change history: No changes on the implementation done in the lab
*
**********************************************************************/

module Nbit_mux2to1#(parameter N = 8)(
    input [N-1:0] a, b,
    input sel,
    output[N-1:0] q
);

    genvar i;

    generate
        for(i = 0; i < N; i=i+1)begin
            Mux_2x1 mux(.a(a[i]), .b(b[i]), .sel(sel), .out(q[i]));
        end
    endgenerate

endmodule