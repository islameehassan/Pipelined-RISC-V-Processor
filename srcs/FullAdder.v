/*******************************************************************
*
* Module: FullAdder.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: A, B, cin
               @outputs: sum, carry
               @importance: displaying data
*
* Change history: No changes on the implementation done in the lab
*
**********************************************************************/

module FullAdder(
    input A, B,
    input cin,
    output sum,
    output carry
);
    assign {carry, sum} = A + B + cin;

endmodule