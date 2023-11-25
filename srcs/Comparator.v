module Comparator(
    input [31:0] a, b,
	output wire  cf, zf, vf, sf // carry, zero, overflow and sign flags
);

    wire [31:0] op_b, add;
    assign op_b = (~b);
    
    assign {cf, add} = (a + op_b + 1'b1);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf); // 1 1 0 1     0111 + 0111

endmodule