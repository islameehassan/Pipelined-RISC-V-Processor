`include "defines.v"

/*******************************************************************
*
* Module: ControlUnit.v
* Project: Pipelined-RISC-V Processor
* Author: Islam Hassan, islamee@aucegypt.edu
* Description: @inputs: inst(opcode)
               @outputs: branch, memread, memtoreg, memwrite, alusrc, regwrite, jalr_jump, jal_jump
                         regwrite_sel, aluop
               @importance: the main control unit of the processor
*
* Change history: 03/11/2023 – created and implemented the module
                  04/11/2023 – corrected some syntax errors
                  04/11/2023 – changed branch signal from 0 tp 1 in jalr 
*
**********************************************************************/

module ControlUnit(
    input [4: 0]inst,
    output reg branch, memread, memtoreg, memwrite, alusrc, regwrite, jalr_jump, jal_jump,
    output reg [1: 0] regwrite_sel,
    output reg [2: 0] aluop
);

    always@(*)begin
        // R-Format
        if(inst == `OPCODE_Arith_R)
        begin
            branch = 0;
            memread = 0;
            memtoreg = 0;
            aluop = `ALUOP_R_I;
            memwrite = 0;
            alusrc = 0;
            regwrite = 1;
            regwrite_sel = 2'b00;
            jalr_jump = 1'b0;
            jal_jump = 1'b0;
        end
        // I-Format (except for load and jalr)
        else if(inst == `OPCODE_Arith_I)
        begin
            branch = 0;
            memread = 0;
            memtoreg = 0;
            aluop = `ALUOP_R_I;
            memwrite = 0;
            alusrc = 1;
            regwrite = 1;
            regwrite_sel = 2'b00;
            jalr_jump = 1'b0;
            jal_jump = 1'b0;
        end
        // Load instructions(lw, lb, lbu, lh, lhu)
        else if(inst == `OPCODE_Load)
        begin
            branch = 0;
            memread = 1;
            memtoreg = 1;
            aluop = `ALUOP_Load_Store;
            memwrite = 0;
            alusrc = 1;
            regwrite = 1;
            regwrite_sel = 2'b00; 
            jalr_jump = 1'b0;
            jal_jump = 1'b0;
        end
        // Store instructions(sw, sb, sh)
        else if(inst == `OPCODE_Store)
        begin
            branch = 0;
            memread = 0;
            memtoreg = 0;
            aluop = `ALUOP_Load_Store;
            memwrite = 1;
            alusrc = 1;
            regwrite = 0;
            regwrite_sel = 2'b00;   
            jalr_jump = 1'b0;    
            jal_jump = 1'b0;      
        end
        // Branch Instructions(BEQ, BNE, BLT, BGE, BLTU, BGEU)
        else if(inst == `OPCODE_Branch)
        begin
            branch = 1;
            memread = 0;
            memtoreg = 0;
            aluop = `ALUOP_Branch;
            memwrite = 0;
            alusrc = 0;
            regwrite = 0;
            regwrite_sel = 2'b00;
            jalr_jump = 1'b0;
            jal_jump = 1'b0;
        end
        // JALR
        else if(inst == `OPCODE_JALR)
        begin
            branch = 1; // it does branching but through another source, so it does not make sense to have branch = 1 here
            memread = 0;
            memtoreg = 0;
            aluop = `ALUOP_JALR;
            memwrite = 0;
            alusrc = 1;
            regwrite = 1;
            regwrite_sel = 2'b01;
            jalr_jump = 1'b1;
            jal_jump = 1'b0;
        end
        // JAL
        else if(inst == `OPCODE_JAL)
        begin
            branch = 0;
            memread = 0;
            memtoreg = 0;
            aluop = `ALUOP_OTHER;
            memwrite = 0;
            alusrc = 0;
            regwrite = 1;
            regwrite_sel = 2'b01;
            jalr_jump = 1'b0;
            jal_jump = 1'b1;
        end
        // LUI
        else if(inst == `OPCODE_LUI)
        begin
            branch = 0;
            memread = 0;
            memtoreg = 0;
            aluop = `ALUOP_OTHER;
            memwrite = 0;
            alusrc = 0;
            regwrite = 1;
            regwrite_sel = 2'b10;
            jalr_jump = 1'b0;
            jal_jump = 1'b0;
        end
        // AUIPC
        else if(inst == `OPCODE_AUIPC)
        begin
            branch = 0;
            memread = 0;
            memtoreg = 0;
            aluop = `ALUOP_OTHER;
            memwrite = 0;
            alusrc = 0;
            regwrite = 1;
            regwrite_sel = 2'b11;
            jalr_jump = 1'b0;
            jal_jump = 1'b0;
        end
        // This includes sys instructions(EBREAK, FENCE, ECALL) and instructions with undefined opcode
        // This simulates no-op.
        else
        begin
            branch = 0;
            memread = 0;
            memtoreg = 0;
            aluop = `ALUOP_OTHER;
            memwrite = 0;
            alusrc = 0;
            regwrite = 0;
            regwrite_sel = 2'b00;
            jalr_jump = 1'b0;
            jal_jump = 1'b0;
        end

    end
endmodule