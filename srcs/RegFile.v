`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 12:21:25 PM
// Design Name: 
// Module Name: RegFile
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


module RegFile#(parameter N = 32)(
    input clk,
    input rst,
    input regwrite,
    input [4: 0] readreg1, readreg2, writereg,
    input [N - 1: 0] writedata,
    output [N - 1 : 0] readdata1, readdata2
);


    reg [N - 1: 0] reg_file[31: 0];

    integer i;

    always@(negedge clk)begin
    if(rst == 1'b1)begin
        for(i = 0; i < 32; i = i + 1)
        begin
            reg_file[i] <= 0;
        end
    end
    else begin
        if(regwrite && writereg != 0)
            reg_file[writereg] <= writedata;
    end
    end

    assign readdata1 = reg_file[readreg1];
    assign readdata2 = reg_file[readreg2];
endmodule