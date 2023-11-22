`ifndef IMM_GEN
`define IMM_GEN
`include "include/defines.v"

/*******************************************************************
*
* Module: ControlUnit.v
* Project: Pipelined-RISC-V Processor
* Author: Adopted from Dr. Cherif Salama
* Description: @inputs: inst
               @outputs: imm
               @importance: generating the immediate
*
* Change history: 03/11/2023 – changed the naming of variables
*
**********************************************************************/
module ImmGen(
	input  wire [31:0]  inst,
    output reg  [31:0]  imm
);

always @(*) begin
	case (inst[`IR_opcode])
		`OPCODE_Arith_I   : 	imm = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] };
		`OPCODE_Store     :     imm = { {21{inst[31]}}, inst[30:25], inst[11:8], inst[7] };
		`OPCODE_LUI       :     imm = { inst[31], inst[30:20], inst[19:12], 12'b0 };
		`OPCODE_AUIPC     :     imm = { inst[31], inst[30:20], inst[19:12], 12'b0}; 				// auipc should have 11 instead of 12 as it will be later shifted
		`OPCODE_JAL       : 	imm = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0 };
		`OPCODE_JALR      : 	imm = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] };
		`OPCODE_Branch    : 	imm = { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
		default           : 	imm = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] }; // imm_I
	endcase 
end

endmodule
`endif