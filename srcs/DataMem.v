`include "defines.v"

/*******************************************************************
*
* Module: DataMem.v
* Project: Pipelined-RISC-V Processor
* Author: Adham El-Asfar, adham_samy@aucegypt.edu
* Description: @inputs: clk, memread, memwrite, func3, addr, data_in
               @outputs: data_out
               @importance: writing and reading from the data memory
*
* Change history: 04/11/2023 – added the implementation of all Load and store
                                (except for lw and sw which were implemented in the lab)
                  04/11/2023 – corrected some errors and added values to the memory for testing
*
**********************************************************************/

module DataMem(
    input clk,
    input memread, memwrite,
    input [2:0] func3,
    input [31:0] addr,
    input [31:0] data_in,
    output reg [31:0] data_out
);

    reg [7: 0] Mem[0: 255];

    always @(*)begin
        if (memread == 1) begin
            case (func3)
                `F3_LB_SB: data_out = {{24{Mem[addr][7]}}, Mem[addr]};                      //LB
                `F3_LH_SH : data_out = {{16{Mem[addr+1][7]}}, Mem[addr+1], Mem[addr]};      //LH
                `F3_LW_SW : data_out = {Mem[addr+3], Mem[addr+2], Mem[addr+1], Mem[addr]};  //LW
                `F3_LBU : data_out = {24'b0, Mem[addr]};                                    //LBU
                `F3_LHU : data_out = {16'b0, Mem[addr+1], Mem[addr]};                       //LHU     	
            endcase
        end
        else
            data_out = 32'b0;
    end

     //Lab6 Test Case using byte-adressable memory
    initial begin
        Mem[0]= 8'b0001_0001;
        Mem[1]=8'b0000_0000;
        Mem[2]=8'b0000_0000;
        Mem[3]=8'b0000_0000;
        Mem[4]=8'b0000_1001;
        Mem[5]=8'b0000_0000;
        Mem[6]=8'b0000_0000;
        Mem[7]=8'b0000_0000;
        Mem[8]=8'b0001_1001;
        Mem[9]=8'b0000_0000;
        Mem[10]=8'b0000_0000;
        Mem[11]=8'b0000_0000;
        Mem[12]=8'b1111_1111;
        Mem[13]=8'b1111_1111;
        Mem[14]=8'b1111_1111;
        Mem[15]=8'b1111_1111;
    end 

    always@(posedge clk)begin
        if(memwrite == 1) begin
            case (func3)
                `F3_LB_SB : Mem[addr] = data_in[7:0];                                       //SB
                `F3_LH_SH : {Mem[addr+1], Mem[addr]} =  data_in[15:0];                      //SH
                `F3_LW_SW : {Mem[addr+3], Mem[addr+2], Mem[addr+1], Mem[addr]} = data_in;   //SW   	
            endcase
        end
    end

endmodule