/*
    This modules handles all the Branching instructions by using the flags provided from the ALU.
*/
`include "include/defines.v"

module BranchingUnit(
    input [2:0] func3,
    input cf, zf, vf, sf,
    output reg r
);
    
    always @ * begin
        case (func3)
            `BR_BEQ : r = zf;            //BEQ
            `BR_BNE : r = ~zf;           //BNE
            `BR_BLT : r = (sf != vf);    //BLT
            `BR_BGE : r = (sf == vf);    //BGE
            `BR_BLTU : r = ~cf;          //BLTU
            `BR_BGEU : r = cf;           //BGEU        	
        endcase
    end
endmodule