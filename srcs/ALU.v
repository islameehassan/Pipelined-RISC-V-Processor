//`include "include/defines.v"
/*`ifndef ALU
`define ALU
`include "Shifter.v"*/
`include "defines.v"
/*******************************************************************
*
* Module: ALU.v
* Project: Pipelined-RISC-V Processor
* Author: Adopted from Dr. Cherif Salama
* Description: @inputs: a, b, shamt, alusel
               @outputs: r, cf, zf, vf, sf
               @importance: operating on a & b and executing the functions selected by alusel. 
                            generating flags to be used later by the branching unit
*
* Change history: No changes
*
**********************************************************************/

module ALU(
    input   wire [31:0] a, b,
	input   wire [4:0]  shamt,  // shift amount
    input   wire [3:0]  alusel,
	output  reg  [31:0] r,
	output  wire  cf, zf, vf, sf // carry, zero, overflow and sign flags
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    
    assign op_b = (~b);
    
    assign {cf, add} = alusel[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf); // 1 1 0 1     0111 + 0111
    wire[31:0] sh;
    // to be implemented
    Shifter shifter0(.a(a), .shamt(shamt), .alusel(alusel[1:0]),  .r(sh));
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alusel)
            // arithmetic
            `ALU_ADD : r = add;
            `ALU_SUB : r = add;
            `ALU_PASS : r = b;
            // logic
            `ALU_OR:  r = a | b;
            `ALU_AND:  r = a & b;
            `ALU_XOR:  r = a ^ b;
            // shift
            `ALU_SLL:  r=sh;        // SLL/ I
            `ALU_SRL:  r=sh;        // SRL/I
            `ALU_SRA:  r=sh;        // SRA/I
            // slt & sltu
            `ALU_SLT:  r = {31'b0,(sf != vf)}; 
            `ALU_SLTU:  r = {31'b0,(~cf)};            	
        endcase
    end
endmodule
//`endif