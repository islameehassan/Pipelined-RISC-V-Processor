/*******************************************************************
*
* Module: ControlUnit.v
* Project: Pipelined-RISC-V Processor
* Author: Adham El-Asfar, adham_samy@aucegypt.edu
* Description: @inputs: addr
               @outputs: data_out
               @importance: storing instructions to be feteched
*
* Change history:  04/11/2023 – three sets of instructions for testing
*
**********************************************************************/

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

    //test case 3
    /* 
    initial begin
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
    end*/
    
    // test case 1
    /*initial begin
        Mem[0]=32'b000000000000_00000_010_00001_0000011;   //lw x1, 0(x0)
        Mem[1]=32'b000000000100_00000_010_00010_0000011;   //lw x2, 4(x0)
        Mem[2]=32'b000000001000_00000_010_00011_0000011;   //lw x3, 8(x0)
        Mem[3]=32'h0052f463;   //bgeu x5, x5, 8
        Mem[4]=32'h0ff0000f;   //fence
        Mem[5]=32'h00215313;   //srli x6, x2, 2
        Mem[6]=32'h0ff0000f;   //fence
        Mem[7]=32'h00119393;   //slli x7, x3, 1
        Mem[8]=32'h00000073;   //ecall
        Mem[9]=32'h40110433;   //sub x8, x2, x1
        Mem[10]=32'h4021d213;   //srai x4, x3, 2	
        Mem[11]=32'h0000a6b7;  //lui x13, 10
        Mem[12]=32'h401184b3;  //sub x9, x3, x1
        Mem[13]=32'h00615533;  //srl x10, x2, x6
        Mem[14]=32'h0ff0000f;   //fence
    end */
    
    // test case 2
   /* initial begin
        Mem[0] = 32'b000000000000_00000_010_00001_0000011;   //lw x1, 0(x0)
        Mem[1] = 32'b000000000100_00000_010_00010_0000011;   //lw x2, 4(x0)
        Mem[2] = 32'b000000001000_00000_010_00011_0000011;   //lw x3, 8(x0)
        Mem[3] = 32'h00c02283;                               // lw x5, 12(x0)           
        Mem[4] = 32'h00614213;      // xori x4, x2, 6
        Mem[5] = 32'h00513333;      //sltu x6, x2, x5 
        Mem[6] = 32'h005123B3;      // slt x7, x2, x5
        Mem[7] = 32'h0051E463;      // bltu x3, x5,
        Mem[8] = 32'h00310233;      // add x4, x2, x3
        Mem[9] = 32'h00000073;      // ecall
        Mem[10] = 32'h00001263;      // bne x0, x0, 4
        Mem[11] = 32'h02713413;      // sltiu x8, x2, 39
        Mem[12] = 32'h00C004EF;      // jal x9, 12
        Mem[13] = 32'h0021DA63;      // bge x3, x2, 20
        Mem[14] = 32'h00000033;     // add x0, x0, x0
        Mem[15] = 32'h00000033;     // add x0, x0, x0
        Mem[16] = 32'h03218593;     // addi x11, x3, 50
        Mem[17] = 32'h00048567;     // jalr x10, x9, 0
        Mem[18] = 32'h00104463;     // blt x0, x1, 8
        Mem[19] = 32'h00000013;     // addi x0, x0, 0
        Mem[20] = 32'h00001617;     // auipc x12, 1
        Mem[21] = 32'h000146B3;     // xor x13, x2, x0
        Mem[22] = 32'hFFF13713;     // sltiu x14, x2, -1
        Mem[23] = 32'hFFF12793;     // slti x15, x2, -1
        Mem[24] = 32'h00416813;     // ori x16, x2, 4
        Mem[25] = 32'h0000F113;     // andi x2, x1, 0
        Mem[26] = 32'h00100073;     // ebreak
        Mem[27] = 32'h00310133;     // add x2, x2, x3
        Mem[28] = 32'h00000013;     // addi x0, x0, 0
    end
    
  //Expected Outcome:
    x1 --> 17
    x2 --> 9
    x3 --> 25
    x4 --> 15
    x5 --> -1
    x6 --> 1
    x7 --> 0
    x8 --> 1
    x9 --> 52
    x10 --> 72
    x11 --> 75
    x12 -- > 4176
    x13 --> 9
    x14 --> 1
    x15 --> 0
    x16 --> 13
    x2 --> 0
    */
    
endmodule
