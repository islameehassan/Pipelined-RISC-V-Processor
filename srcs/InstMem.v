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

        Mem[0]=32'b000000000000_00000_010_00001_0000011 ;   //lw x1, 0(x0)
        Mem[1]=32'b000000000100_00000_010_00010_0000011 ;   //lw x2, 4(x0)
        Mem[2]=32'b000000001000_00000_010_00011_0000011 ;   //lw x3, 8(x0)
        Mem[3]=32'b0000000_00010_00001_110_00100_0110011 ;  //or x4, x1, x2
        Mem[4]=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4
        Mem[5]=32'b0000000_00010_00001_000_00011_0110011 ;  //add x3, x1, x2
        Mem[6]=32'b0000000_00010_00011_000_00101_0110011 ;  //add x5, x3, x2
        Mem[7]=32'b0000000_00101_00000_010_01100_0100011;   //sw x5, 12(x0)
        Mem[8]=32'b000000001100_00000_010_00110_0000011 ;   //lw x6, 12(x0)
        Mem[9]=32'b0000000_00001_00110_111_00111_0110011 ;  //and x7, x6, x1
        Mem[10]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
        Mem[11]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
        Mem[12]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
    end 
endmodule
