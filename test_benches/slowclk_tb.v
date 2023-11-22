`include "slowclk.v"
module slowclk_tb();

    localparam clk_period = 20;


    reg clk;
    reg rst;
    wire slow_clkk;

    slow_clk sc(clk, rst, slow_clk);

    initial begin
        $dumpfile("slow_clk.vcd");
        $dumpvars(0,slowclk_tb);
        clk = 0;
        rst = 1;
        #clk_period 
        clk = 1;
        #clk_period 
        rst = 0;
        clk = 0;
        #clk_period 
        forever begin
            clk = ~clk;
            #clk_period;
        end
    end
endmodule
