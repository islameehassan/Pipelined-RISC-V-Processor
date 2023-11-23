/*`ifdef DATAPATH_TB
`include"Datapath.v"*/

/*******************************************************************
*
* Module: Datapath_tb.v
* Project: Pipelined-RISC-V Processor
* Author: @all
* Description: @inputs: 
               @outputs:
               @importance: testing the datapath
*
* Change history: No changes were made on the lab implementation
*
**********************************************************************/
module DataPath_tb();

    localparam clk_period = 20;

    reg clk;
    reg Reset;
    reg [1:0] ledSel;
    reg [3:0] ssdSel;
    reg SSD_Clock;
    wire [15:0] leds;
    wire [12:0] ssd;

    Datapath dp(clk, Reset, ledSel, ssdSel, leds, ssd);

    initial begin
        /*$dumpfile("Datapath.vcd");
        $dumpvars(0,DataPath_tb);*/
        ssdSel = 4'b0101;
        clk = 0;
        Reset = 1;
        #clk_period 
        clk = 1;
        #clk_period
        Reset = 0; 
        clk = 0;
        #clk_period 
        forever begin
            clk = ~clk;
            #clk_period;
        end
    end
endmodule
//`endif
