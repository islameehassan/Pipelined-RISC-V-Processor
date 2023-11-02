`include "FullAdder.v"

module RCA #(parameter N = 8)(input [N - 1: 0] a, b, output[N: 0] sum);

    wire [N: 0] cin;
    genvar i;

    assign cin[0] = 0;
    generate
        for(i = 0; i < N; i=i+1)begin 
            FullAdder FA(a[i], b[i],cin[i], sum[i], cin[i + 1]);
        end
    endgenerate
    assign sum[N] = cin[N];
endmodule