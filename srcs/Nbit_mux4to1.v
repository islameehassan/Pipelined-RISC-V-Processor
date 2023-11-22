`ifndef NBIT_MUX4TO1_V
`define NBIT_MUX4TO1_V

// `include "srcs/Mux_2x1.v"

module Nbit_mux4to1 #(parameter n = 8)(
	input[n-1:0] a, b, c, d,
	input[1:0] sel,
	output[n-1:0] q
);

	wire[n-1:0] mux1_output, mux2_output;
	genvar i;

	generate
	    for(i = 0; i < n; i=i+1)begin
			Mux_2x1 mu1x(.a(a[i]), .b(c[i]), .sel(sel[1]), .out(mux1_output[i]));
			Mux_2x1 mu2x(.a(b[i]), .b(d[i]), .sel(sel[1]), .out(mux2_output[i]));
			Mux_2x1 mu3x(.a(mux1_output[i]), .b(mux2_output[i]), .sel(sel[0]), .out(q[i]));
	    end
	endgenerate
endmodule
`endif