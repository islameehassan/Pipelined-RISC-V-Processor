/*
    This modules handles exceptions and undefined behaviors by setting a signal called halt equal to 1
    , which is responsible for pausing the CPU, i.e., not taking any instructions. 
    Important for debugging.
*/
`include "include/defines.v"

module HaltingUnit(
    input[4: 0] inst,
    input ebreak_bit,   // bit 20 in ebreak, used to set halt to 1 automatically
    output halt
);
    always@(inst or ebreak_bit)
    begin
        if(inst == `OPCODE_SYSTEM)
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