`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2023 11:48:03 AM
// Design Name: 
// Module Name: Four_Digit_Seven_Segment_Driver
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


module Four_Digit_Seven_Segment_Driver ( 
    input clk,
    input [12:0] num, 
    output reg [3:0] anode, 
    output reg [6:0] led_out
);

    reg [3:0] led_bcd;
    reg [19:0] refresh_counter = 0; // 20-bit counter
    wire [1:0] led_activating_counter;

    always @(posedge clk)
    begin
        refresh_counter <= refresh_counter + 1;
    end

    assign led_activating_counter = refresh_counter[19:18]; 
    always @(*) 
    begin
        case(led_activating_counter) 
            2'b00: 
            begin
                anode = 4'b0111; 
                led_bcd = num/1000;
            end
            2'b01:
            begin
                anode = 4'b1011;
                led_bcd = (num % 1000)/100;
            end
            2'b10:
            begin
                anode = 4'b1101;
                led_bcd = ((num % 1000)%100)/10;
            end
            2'b11:
            begin
                anode = 4'b1110;
                led_bcd = ((num % 1000)%100)%10;
            end 
        endcase 
    end

    always @(*)
    begin
        case(led_bcd)
            4'b0000: led_out = 7'b0000001; // "0"
            4'b0001: led_out = 7'b1001111; // "1"
            4'b0010: led_out = 7'b0010010; // "2"
            4'b0011: led_out = 7'b0000110; // "3"
            4'b0100: led_out = 7'b1001100; // "4"
            4'b0101: led_out = 7'b0100100; // "5"
            4'b0110: led_out = 7'b0100000; // "6"
            4'b0111: led_out = 7'b0001111; // "7"
            4'b1000: led_out = 7'b0000000; // "8"
            4'b1001: led_out = 7'b0000100; // "9"
            default: led_out = 7'b0000001; // "0"
        endcase 
    end
endmodule