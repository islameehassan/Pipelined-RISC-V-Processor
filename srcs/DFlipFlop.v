`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2023 10:44:30 AM
// Design Name: 
// Module Name: DFlipFlop
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


module DFlipFlop(
    input clk,
    input rst,
    input d,
    output reg q
);

    always @ (posedge clk or posedge rst)
        if (rst) begin
            q <= 1'b0;
        end else begin
            q <= d;
    end
endmodule