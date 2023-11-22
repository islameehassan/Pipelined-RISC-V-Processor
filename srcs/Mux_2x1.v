`ifndef MUX_2x1
`define MUX_2x1
/*******************************************************************
*
* Module: Mux_2x1.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: a, b, sel
               @outputs: out
               @importance: selecting from two inputs based on sel
*
* Change history: No changes on the implementation done in the lab
*
**********************************************************************/

module Mux_2x1(
    input a, b,
    input sel,
    output out
);

    assign out = (sel == 1'b1)? a: b;

endmodule
`endif