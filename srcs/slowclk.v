`ifndef SLOWCLK_V
`define SLOWCLK_V
`include "srcs/DFlipFlop.v"

module slow_clk(
    input clk,
    input rst,
    output slow_clk
);

    DFlipFlop dff0(.clk(clk), .rst(rst), .d(~slow_clk), .q(slow_clk));
endmodule
`endif