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
    input [2: 0] aluop,
    input [2: 0] func3,
    input func7bit,
    output reg [3: 0] alusel
);


    always@(*)begin
        // Arithmetic and Logical Instructions
        if(aluop == `ALUOP_R_I)
        begin
            // ADD & ADDI & SUB
            if(func3 == `F3_ADD)
            begin
                if(func7bit == 1'b1)
                    alusel = `ALU_SUB;
                else
                    alusel = `ALU_ADD;
            end
            // SLL & SLLI
            else if(func3 == `F3_SLL)
            begin
                alusel = `ALU_SLL;
            end
            // SLT & SLTU
            else if(func3 == `F3_SLT)
            begin
                alusel = `ALU_SLT;
            end
            // SLTU & SLTIU
            else if(func3 == `F3_SLTU)
            begin
                alusel = `ALU_SLTU;
            end
            // XOR & XORI
            else if(func3 == `F3_XOR)
            begin
                alusel = `ALU_XOR;
            end
            // SRL & SRLI & SRA & SRAI
            else if(func3 == `F3_SRL)
            begin
                if(func7bit == 1'b1)
                    alusel = `ALU_SRA;
                else
                    alusel = `ALU_SRL;
            end
            // OR & ORI
            else if(func3 == `F3_OR)
            begin
                alusel = `ALU_OR;
            end
            // AND & ANDI
            else if(func3 == `F3_AND)
            begin
                alusel = `ALU_AND;
            end
            else
                alusel = `ALU_PASS;
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