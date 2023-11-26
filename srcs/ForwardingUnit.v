/*`ifndef FORWARDINGUNIT_V
`define FORWARDINGUNIT_V*/
/*******************************************************************
*
* Module: ForwardingUnit.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd
                        EX_MEM_regwrite, MEM_WB_regwrite
               @outputs: forwardA, forwardB
               @importance: forward in case of data hazards
*
* Change history: No changes on the implementation done in the lab
*
**********************************************************************/
module ForwardingUnit(
    input [4:0] ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd, 
    input [4:0] inst_rs1, inst_rs2,
    input EX_MEM_regwrite, MEM_WB_regwrite,
    output reg forward_branchA, forward_branchB,
    output reg [1:0] forwardA, forwardB
);
        
    always @(*) begin
        forwardA = 2'b00;
        forwardB = 2'b00;
        if(MEM_WB_regwrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs1)) // Removed  && !(EX_MEM_regwrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1))
            forwardA = 2'b01;
        if(MEM_WB_regwrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs2)) // Removed  && !(EX_MEM_regwrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2))
            forwardB = 2'b01;

        forward_branchA = 1'b0;
        forward_branchB = 1'b0;
        if(EX_MEM_regwrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == inst_rs1))
            forward_branchA = 1'b1;
        if(EX_MEM_regwrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == inst_rs2))
            forward_branchB = 1'b1;
    end
           
endmodule
//`endif
