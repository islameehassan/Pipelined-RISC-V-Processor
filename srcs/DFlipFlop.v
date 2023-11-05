/*******************************************************************
*
* Module: DFlipFlop.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: clk, rst, d
               @outputs: q
               @importance: store unit
*
* Change history: No changes on the implementation done in the lab
*
**********************************************************************/

module DFlipFlop(
    input clk,
    input rst,
    input d,
    output reg q
);

    always @ (posedge clk or posedge rst)
        if (rst) begin
            q <= 1'b0;
        end else begin
            q <= d;
    end
endmodule