`timescale 1ns / 1ps
/*`include "srcs/InstMem.v"
`include "srcs/RegFile.v"
`include "srcs/ControlUnit.v"
`include "srcs/ImmGen.v"
`include "srcs/ALU_ControlUnit.v"
`include "srcs/ALU.v"
`include "srcs/DataMem.v"
`include "srcs/Nbit_ShiftLeftBy1.v"
`include "srcs/RCA.v"
`include "srcs/Nbit_Register.v"
*/
`define     IR_rs1          19:15
`define     IR_rs2          24:20
`define     IR_rd           11:7
`define     IR_opcode       6:2
`define     IR_funct3       14:12
`define     IR_funct7       31:25
`define     IR_shamt        24:20

`define     OPCODE_Branch               5'b11_000
`define     OPCODE_Load                 5'b00_000
`define     OPCODE_Store                5'b01_000
`define     OPCODE_JALR                 5'b11_001
`define     OPCODE_JAL                  5'b11_011
`define     OPCODE_Arith_I              5'b00_100
`define     OPCODE_Arith_R              5'b01_100
`define     OPCODE_AUIPC                5'b00_101
`define     OPCODE_LUI                  5'b01_101
`define     OPCODE_SYSTEM               5'b11_100
`define     OPCODE_SYSTEM_FENCE         5'b00_111 
`define     OPCODE_Custom               5'b10_001

`define     F3_ADD          3'b000
`define     F3_SLL          3'b001
`define     F3_SLT          3'b010
`define     F3_SLTU         3'b011
`define     F3_XOR          3'b100
`define     F3_SRL          3'b101
`define     F3_OR           3'b110
`define     F3_AND          3'b111

`define    F3_MUL           3'b000
`define    F3_MULH          3'b001
`define    F3_MULHSU        3'b010
`define    F3_MULHU         3'b011
`define    F3_DIV           3'b100
`define    F3_DIVU          3'b101
`define    F3_REM           3'b110
`define    F3_REMU          3'b111

`define     F3_LB_SB        3'b000
`define     F3_LH_SH        3'b001
`define     F3_LW_SW        3'b010
`define     F3_LBU          3'b100
`define     F3_LHU          3'b101

`define     F7_MUL          7'b0000001
`define     F7_SUB_SRA      7'b0100000

`define     BR_BEQ          3'b000
`define     BR_BNE          3'b001
`define     BR_BLT          3'b100
`define     BR_BGE          3'b101
`define     BR_BLTU         3'b110
`define     BR_BGEU         3'b111

`define     OPCODE          IR[`IR_opcode]

`define     ALU_ADD         5'b00000
`define     ALU_SUB         5'b00001
`define     ALU_PASS        5'b00011
`define     ALU_OR          5'b00100
`define     ALU_AND         5'b00101
`define     ALU_XOR         5'b00111
`define     ALU_SRL         5'b01000
`define     ALU_SRA         5'b01010
`define     ALU_SLL         5'b01001
`define     ALU_SLT         5'b01101
`define     ALU_SLTU        5'b01111

`define     ALU_MUL         5'b10000 
`define     ALU_MULH        5'b10001
`define     ALU_MULHSU      5'b10010
`define     ALU_MULHU       5'b10011
`define     ALU_DIV         5'b10100
`define     ALU_DIVU        5'b10101
`define     ALU_REM         5'b10110
`define     ALU_REMU        5'b10111

`define     SYS_EC_EB       3'b000	    

`define     ALUOP_R_I             3'b000
`define     ALUOP_Load_Store      3'b001
`define     ALUOP_Branch          3'b010
`define     ALUOP_JALR            3'b011
`define     ALUOP_OTHER           3'b111 

`define     NOP                   32'h00000033
