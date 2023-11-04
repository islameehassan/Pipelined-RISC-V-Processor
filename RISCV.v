`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2023 11:46:26 AM
// Design Name: 
// Module Name: RISC-V
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RISCV(
    input Clock,
    input Reset,
    input [1:0] ledSel,
    input [3:0] ssdSel,
    input SSD_Clock, 
    output [3:0] Anode, 
    output [6:0] LED_out,
    output [15:0] leds
     
);

wire [12:0]num_to_be_displayed;

Datapath dp(Clock, Reset, ledSel, ssdSel, leds, num_to_be_displayed);
Four_Digit_Seven_Segment_Driver ssd(SSD_Clock,num_to_be_displayed, Anode, LED_out);

endmodule
