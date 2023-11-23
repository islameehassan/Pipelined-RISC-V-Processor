/*`ifndef INSTMEM
`define INSTMEM*/
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



module InstMem(
    input [31:0] addr,
    output [31:0] data_out
);
    reg [31: 0] Mem [0: 63];
    assign data_out = Mem[addr/4];
    
    // test case 1
    /*
    initial begin
        Mem[0] = 32'h00002083;      //lw x1, 0(x0)
        Mem[1] = 32'h00402103;      //lw x2, 4(x0)
        Mem[2] = 32'h00802183;      //lw x3, 8(x0)
        Mem[3]=32'h0052f463;        //bgeu x5, x5, 8
        Mem[4]=32'h0ff0000f;        //fence
        Mem[5]=32'h00215313;        //srli x6, x2, 2
        Mem[6]=32'h0ff0000f;        //fence
        Mem[7]=32'h00119393;        //slli x7, x3, 1
        Mem[8]=32'h00000073;        //ecall
        Mem[9]=32'h40110433;        //sub x8, x2, x1
        Mem[10]=32'h4021d213;       //srai x4, x3, 2	
        Mem[11]=32'h0000a6b7;       //lui x13, 10
        Mem[12]=32'h401184b3;       //sub x9, x3, x1
        Mem[13]=32'h00615533;       //srl x10, x2, x6
        Mem[14]=32'h0ff0000f;       //fence
    end 
    */
    
    // test case 2
    /*
    initial begin
        Mem[0] = 32'h00002083;      //lw x1, 0(x0)
        Mem[1] = 32'h00402103;      //lw x2, 4(x0)
        Mem[2] = 32'h00802183;      //lw x3, 8(x0)
        Mem[3] = 32'h00c02283;      // lw x5, 12(x0)           
        Mem[4] = 32'h00614213;      // xori x4, x2, 6
        Mem[5] = 32'h00513333;      //sltu x6, x2, x5 
        Mem[6] = 32'h005123B3;      // slt x7, x2, x5
        Mem[7] = 32'h0051E463;      // bltu x3, x5,
        Mem[8] = 32'h00310233;      // add x4, x2, x3
        Mem[9] = 32'h00000073;      // ecall
        Mem[10] = 32'h00001263;     // bne x0, x0, 4
        Mem[11] = 32'h02713413;     // sltiu x8, x2, 39
        Mem[12] = 32'h00C004EF;     // jal x9, 12
        Mem[13] = 32'h0021DA63;     // bge x3, x2, 20
        Mem[14] = 32'h03218593;     // addi x11, x3, 50
        Mem[15] = 32'h00048567;     // jalr x10, x9, 0
        Mem[16] = 32'h00104463;     // blt x0, x1, 8
        Mem[17] = 32'h00000013;     // addi x0, x0, 0
        Mem[18] = 32'h00001617;     // auipc x12, 1
        Mem[19] = 32'h000146B3;     // xor x13, x2, x0
        Mem[20] = 32'hFFF13713;     // sltiu x14, x2, -1
        Mem[21] = 32'hFFF12793;     // slti x15, x2, -1
        Mem[22] = 32'h00416813;     // ori x16, x2, 4
        Mem[23] = 32'h0000F113;     // andi x2, x1, 0
        Mem[24] = 32'h03218593;     // addi x11, x3, 50
        Mem[25] = 32'h00100073;     // ebreak
        Mem[26] = 32'h00310133;     // add x2, x2, x3
        Mem[27] = 32'h00000013;     // addi x0, x0, 0
    end
    */
    
    //test case 3    
    /*
    initial begin
        Mem[0] = 32'h00002083;      //lw x1, 0(x0)
        Mem[1] = 32'h00402103;      //lw x2, 4(x0)
        Mem[2] = 32'h00802183;      //lw x3, 8(x0)
        Mem[3] = 32'h0020E233;      //or x4, x1, x2
        Mem[4] = 32'h00320463;      //beq x4, x3, 8
        Mem[5] = 32'h002081B3;      //add x3, x1, x2
        Mem[6] = 32'h002182B3;      //add x5, x3, x2
        Mem[7] = 32'h00502623;      //sw x5, 12(x0)
        Mem[8] = 32'h00C02303;      //lw x6, 12(x0)
        Mem[9] = 32'h001373B3;      //and x7, x6, x1
        Mem[10] = 32'h40208433;     //sub x8, x1, x2
        Mem[11] = 32'h00208033;     //add x0, x1, x2
        Mem[12] = 32'h001004B3;     //add x9, x0, x1
    end
    */
    
endmodule
//`endif