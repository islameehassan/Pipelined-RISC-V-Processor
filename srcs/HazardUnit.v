`ifndef HAZARDUNIT_V
`define HAZARDUNIT_V
/*******************************************************************
*
* Module: HazardUnit.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: IF_ID_Rs1, ID_ID_Rs2, ID_EX_Rd
                        ID_EX_MemRead
               @outputs: stall
               @importance: detecting lad-use hazards, and set stall = 1 if any exists
*
* Change history: No changes on the implementation done in the lab
*
**********************************************************************/

module HazardUnit(
    input [4:0] IF_ID_Rs1, IF_ID_Rs2, ID_EX_Rd, 
    input ID_EX_MemRead, 
    output reg stall
    );
    
    always@(*) begin
        if(((IF_ID_Rs1 == ID_EX_Rd) || (IF_ID_Rs2 == ID_EX_Rd)) && (ID_EX_MemRead) && (ID_EX_Rd != 0))
            stall = 1;
        else
            stall = 0;    
    end
endmodule
`endif
