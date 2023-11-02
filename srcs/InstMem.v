`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 10:42:29 AM
// Design Name: 
// Module Name: InstMem
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


module InstMem(
    input [31:0] addr,
    output [31:0] data_out
);
    reg [31: 0] Mem [0: 63];
    assign data_out = Mem[addr/4];

    initial begin
        /* This program flips the signs of array elements stored in the data section. The array starts at address zero and has the following values: 1, -2, 3, -4, 5, 6, 0. Zero is there to terminate the loop.*/ 

            Mem[0]=32'b0000000111000000001001010_0000011;			//lw x10, 28(x0)
            Mem[1]=32'b000000000000_01000_010_01001_0000011;		//lw x9, 0(x8)
            Mem[2]=32'b0000000000000100100010100_1100011;			//beq x9, x0, 20
            Mem[3]=32'b000000001010_01001_000_01001_0110011;		//add x9, x9, x10
            Mem[4]=32'b0000000_01001_01000_010_00000_0100011;		//sw x9, 0(x8)
            Mem[5]=32'b0000000_01010_01000_000_01000_0110011;		//add x8, x8, x10
            Mem[6]=32'b1111111000010000100001101_1100011;			//beq x1, x1, -20
    end 
endmodule
