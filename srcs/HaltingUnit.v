/*******************************************************************
*
* Module: HaltingUnit.v
* Project: Pipelined-RISC-V Processor
* Author: Islam Hassan, islamee@aucegypt.edu
* Description: @inputs: inst(opcode), ebreak_bit
               @outputs: halt
               @importance: halting the processor if an ebreak instruction 
                            is encountered
*
* Change history: 03/11/2023 – created and implemented the module
*
**********************************************************************/
`include "defines.v"

module HaltingUnit(
    input[4: 0] inst,
    input ebreak_bit,   // bit 20 in ebreak, used to set halt to 1 automatically
    output reg halt
);
    always@(inst or ebreak_bit)
    begin
        if(inst == `OPCODE_SYSTEM && ebreak_bit)
        begin
            halt = 1'b1;
        end
        // TODO: handles other cases where setting 1'b1 is important
        //
        //
        else
        begin
            halt = 1'b0;
        end
    end
endmodule