/*******************************************************************
*
* Module: Nbit_ShifterLeftBy1.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: a
               @outputs: b
               @importance: shifting a left by 1 and storing in b
*
* Change history: No changes on the implementation done in the lab
*
* Notes: not used since immGen already outputs immediates shifted if needed
**********************************************************************/

module Nbit_ShiftLeftBy1 #(parameter N = 8)(
   input[N-1:0] a,
   output[N-1:0] b
);
   
   assign b[N-1:1] = a[N-2:0];
   assign b[0] = 1'b0;

endmodule
