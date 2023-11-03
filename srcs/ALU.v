`include "include/defines.v"

// module ALU#(parameter N = 32)(
//     input [N - 1: 0] A,
//     input [N - 1: 0] B,
//     input [3:0] sel,
//     output reg [N - 1: 0]ALUOutput,
//     output ZeroFlag
// );


//     wire [N - 1:0] Bnew;
//     wire [N - 1: 0] result;
//     assign Bnew = (sel[2])? (~B + 1): (B);

//     RCA #(.N(N))rca_inst(A, Bnew, result);

//     always@(*)begin
//     case (sel)
//         4'b0000: ALUOutput = A & B;
//         4'b0001: ALUOutput = A | B;
//         4'b0010: ALUOutput = result;
//         4'b0110: ALUOutput = result;
//         default: ALUOutput = 0;  
//     endcase
//     end

//     assign ZeroFlag = (ALUOutput == 0);

// endmodule

module ALU(
    input   wire [31:0] a, b,
	input   wire [4:0]  shamt,  // shift amount
	output  reg  [31:0] r,
	output  wire  cf, zf, vf, sf, // carry, zero, overflow and sign flags
	input   wire [3:0]  alufn
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] sh;
    // to be implemented
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            4'b00_00 : r = add;
            4'b00_01 : r = add;
            4'b00_11 : r = b;
            // logic
            4'b01_00:  r = a | b;
            4'b01_01:  r = a & b;
            4'b01_11:  r = a ^ b;
            // shift
            4'b10_00:  r=sh;
            4'b10_01:  r=sh;
            4'b10_10:  r=sh;
            // slt & sltu
            4'b11_01:  r = {31'b0,(sf != vf)}; 
            4'b11_11:  r = {31'b0,(~cf)};            	
        endcase
    end
endmodule