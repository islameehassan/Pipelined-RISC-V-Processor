
module Nbit_ShiftLeftBy1 #(parameter N = 8)(
   input[N-1:0] a,
   output[N-1:0] b
);
   
   assign b[N-1:1] = a[N-2:0];
   assign b[0] = 1'b0;

endmodule
