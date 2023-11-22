`ifndef FORWARDINGUNIT_V
`define FORWARDINGUNIT_V
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
    input EX_MEM_regwrite, MEM_WB_regwrite,
    output reg [1:0] forwardA, forwardB
);
        
    always @(*) begin
        
        if(EX_MEM_regwrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1))
            forwardA = 2'b10;
        else if(EX_MEM_regwrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2))
            forwardB = 2'b10;
        else if(MEM_WB_regwrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs1) && !(EX_MEM_regwrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1)))
            forwardA = 2'b01;
        else if(MEM_WB_regwrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs2) && !(EX_MEM_regwrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2)))
            forwardB = 2'b01;
        else begin
            forwardA = 2'b00;
            forwardB = 2'b00;
        end
    end
           
endmodule
`endif
