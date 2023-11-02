
module FullAdder(
    input A, B,
    input cin,
    output sum,
    output carry
);
    assign {carry, sum} = A + B + cin;

endmodule