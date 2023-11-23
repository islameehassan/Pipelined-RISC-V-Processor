/*`ifndef REG_FILE_V
`define REG_FILE_V*/
/*******************************************************************
*
* Module: RegFile.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: clk, rst, regwrite
                        readreg1, readreg2, writereg, writedata
               @outputs: readdata1, readdata2
               @importance: storing the values of 32 general-purpose registers
*
* Change history: No changes on the implementation done in the lab
*
**********************************************************************/


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

    always@(posedge clk)begin
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
//`endif