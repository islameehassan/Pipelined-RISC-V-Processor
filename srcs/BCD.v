/*******************************************************************
*
* Module: BCD.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: num
               @outputs: thousands, hundreds, tens, ones
               @importance: generating thousands, hundreds, tens, and ones
                            for the 7-segment display
*
* Change history: No changes on the implementation done in the lab
*
**********************************************************************/

module BCD ( 
input [12:0] num, 
output reg [3:0] thousands,
output reg [3:0] hundreds, 
output reg [3:0] tens, 
output reg [3:0] ones 
); 
    integer i; 
    always @(num)
    begin 
        //initialization 
        thousands = 4'd0;
        hundreds = 4'd0; 
        tens = 4'd0; 
        ones = 4'd0; 
        for (i = 12; i >= 0 ; i = i-1 ) 
        begin 
            if(thousands >= 5 ) 
                thousands = thousands + 3;
            if(hundreds >= 5 ) 
                hundreds = hundreds + 3; 
            if (tens >= 5 ) 
                tens = tens + 3; 
            if (ones >= 5) 
                ones = ones +3; 
            //shift left one 

            thousands = thousands << 1; 
            thousands [0] = hundreds [3]; 
            hundreds = hundreds << 1; 
            hundreds [0] = tens [3]; 
            tens = tens << 1; 
            tens [0] = ones[3]; 
            ones = ones << 1; 
            ones[0] = num[i]; 
        end 
    end 
endmodule