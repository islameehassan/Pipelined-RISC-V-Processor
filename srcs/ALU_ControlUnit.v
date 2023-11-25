/*`ifndef ALU_CONTROLUNIT_V
`define ALU_CONTROLUNIT_V
`include "include/defines.v"
*/
`include "defines.v"

/*******************************************************************
*
* Module: ALU_ControlUnit.v
* Project: Pipelined-RISC-V Processor
* Author: Islam Hassan, islamee@aucegypt.edu
* Description: @inputs: aluop, func3, func7
               @outputs: alusel
               @importance: generating alusel which determines which mathematical
               function to be executed by the ALU
*
* Change history: 03/11/2023 – created and implemented the module
*                 04/11/2023 – corrected some syntax errors
*
**********************************************************************/
module ALU_ControlUnit(
    input [4:0] opcode,             // ADD this to the DATAPATH
    input [2:0] aluop,
    input [2:0] func3,
    input [6:0] func7,              // ADD this to the DATAPATH
    output reg [4:0] alusel
);


    always@(*)begin
        // Arithmetic and Logical Instructions
        if(aluop == `ALUOP_R_I)
        begin
            // M Instructions
            if(func7 == `F7_MUL && opcode == `OPCODE_Arith_R)
            begin                                             
                case(func3)
                    `F3_MUL: alusel = `ALU_MUL;
                    `F3_MULH: alusel = `ALU_MULH;
                    `F3_MULHSU: alusel = `ALU_MULHSU;
                    `F3_MULHU: alusel = `ALU_MULHU;
                    `F3_DIV: alusel = `ALU_DIV;
                    `F3_DIVU: alusel = `ALU_DIVU;
                    `F3_REM: alusel = `ALU_REM;
                    `F3_REMU: alusel = `ALU_REMU;
                    default: alusel = `ALU_PASS;
                endcase
            end
            else 
            begin
                // R and I Instructions
                case(func3)
                    `F3_ADD: // ADD & ADDI & SUB
                        begin
                            if(func7 == `F7_SUB_SRA)
                                alusel = `ALU_SUB;
                            else
                                alusel = `ALU_ADD;
                        end
                    `F3_SLL: alusel = `ALU_SLL;         // SLL & SLLI
                    `F3_SLT: alusel = `ALU_SLT;         // SLT & SLTI
                    `F3_SLTU: alusel = `ALU_SLTU;       // SLTU & SLTIU
                    `F3_XOR: alusel = `ALU_XOR;         // XOR & XORI
                    `F3_SRL:                            // SRL & SRLI & SRA & SRAI
                        begin
                            if(func7 == `F7_SUB_SRA)
                                alusel = `ALU_SRA;
                            else
                                alusel = `ALU_SRL;
                        end     
                    `F3_OR: alusel = `ALU_OR;           // OR & ORI
                    `F3_AND: alusel = `ALU_AND;         // AND & ANDI
                    default: alusel = `ALU_PASS;        // default case
                endcase
            end
        end
        // ADD for Store and Load
        else if(aluop == `ALUOP_Load_Store)
        begin
            alusel = `ALU_ADD;
        end
        // SUB for Branch
        else if(aluop == `ALUOP_Branch)
        begin
            alusel = `ALU_SUB;
        end
        // ADD for JALR
        else if(aluop == `ALUOP_JALR)
        begin
            alusel = `ALU_ADD;
        end
        // Other: default case
        else
        begin
            alusel = `ALU_PASS;
        end
    end
endmodule
//`endif