`include"srcs/Datapath.v"
module DataPath_tb();

    localparam clk_period = 20;


    reg Clock;
    reg Reset;
    reg [1:0] ledSel;
    reg [3:0] ssdSel;
    reg SSD_Clock;
    wire [15:0] leds;
    wire [12:0] ssd;

    Datapath dp(Clock, Reset, ledSel, ssdSel, leds, ssd);

    initial begin
        $dumpfile("Datapath.vcd");         //This specifies the output file of the waveform from iverilog
        $dumpvars(0,DataPath_tb);
        ssdSel = 4'b0101;
        Clock = 0;
        Reset = 1;
        #clk_period 
        Clock = 1;
        #clk_period 
        Reset = 0;
        Clock = 0;
        #clk_period 
        forever begin
            #clk_period
            Clock = ~Clock;
        end
    end
endmodule
