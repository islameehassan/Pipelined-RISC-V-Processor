/*`ifndef BRANCHING_UNIT
`define BRANCHING_UNIT
`include "include/defines.v"*/
`include "defines.v"
/*******************************************************************
*
* Module: BranchingUnit.v
* Project: Pipelined-RISC-V Processor
* Author: Adham El-Asfar, adham_samy@aucegypt.edu
* Description: @inputs: func3, cf, zf, vf, sf, jalr_jump
               @outputs: r
               @importance: deciding if to branch or not by setting r to 1 if branching
                            and zero if not.
*
* Change history: 03/11/2023 – created and implemented the module
                  04/11/2023 – added jalr_jump to handle this special kind of branching/jumping here 
*
**********************************************************************/

module BranchingUnit(
    input [2:0] func3,
    input cf, zf, vf, sf,
    input jalr_jump,
    output reg r
);
    
    always @ * begin
        case (func3)
            `BR_BEQ  : r = zf ;           //BEQ  or JALR
            `BR_BNE : r = ~zf;                           //BNE
            `BR_BLT : r = (sf != vf);                    //BLT
            `BR_BGE : r = (sf == vf);                    //BGE
            `BR_BLTU : r = ~cf;                          //BLTU
            `BR_BGEU : r = cf;                           //BGEU
            default : r = 1'b0;        	
        endcase
    end
endmodule
//`endif