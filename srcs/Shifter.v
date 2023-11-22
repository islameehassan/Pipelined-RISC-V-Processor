`ifndef SHIFTER_V
`define SHIFTER_V
/*******************************************************************
*
* Module: Shifter.v
* Project: Pipelined-RISC-V Processor
* Author: Islam Hassan, islamee@aucegypt.edu
* Description: @inputs: a, shamt, alusel
               @outputs: r
               @importance: shifting a by shamt according to alusel(left, right logical or arthimetic)
*
* Change history: 03/11/2023 – created and implemented the module
                  04/11/2023 – corrected an error in the logic
*
**********************************************************************/
/*
    shifts r left or right(logical and arthimetic)
*/

module Shifter(
    input[31: 0] a,
    input[4: 0] shamt,
    input[1: 0] alusel,
    output reg[31: 0] r
);
    always@(*)
    begin
        // default: no shift
        r = a;

        // SRL & SRLI
        if(alusel == 2'b00)
        begin
            r = a >> shamt;
        end
        // SLL & SLI
        else if(alusel == 2'b01)
        begin
            r = a << shamt;
        end
        // SRA & SRAI
        else if(alusel == 2'b10)
        begin
            r = a >>> shamt;
        end
    end
endmodule
`endif