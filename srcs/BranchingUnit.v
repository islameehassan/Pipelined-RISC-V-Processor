/*
    This modules handles all the Branching instructions by using the flags provided from the ALU.
*/
`include "defines.v"

module BranchingUnit(
    input [2:0] func3,
    input cf, zf, vf, sf,
    input jalr_jump,
    output reg r
);
    
    always @ * begin
        case (func3)
            `BR_BEQ  : r = (zf || jalr_jump) ;           //BEQ  or JALR
            `BR_BNE : r = ~zf;                           //BNE
            `BR_BLT : r = (sf != vf);                    //BLT
            `BR_BGE : r = (sf == vf);                    //BGE
            `BR_BLTU : r = ~cf;                          //BLTU
            `BR_BGEU : r = cf;                           //BGEU
            default : r = 1'b0;        	
        endcase
    end
endmodule