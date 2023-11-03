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

        // SLL & SLI
        if(alusel == 2'b00)
        begin
            r = a << shamt;
        end
        // SRL & SRLI
        else if(alusel == 2'b01)
        begin
            r = a >> shamt;
        end
        // SRA & SRAI
        else if(alusel == 2'b10)
        begin
            r = a >>> shamt;
        end
    end
endmodule