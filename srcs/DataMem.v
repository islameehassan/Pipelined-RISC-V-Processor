
module DataMem(
    input clk,
    input memread, memwrite,
    input [5:0] addr,
    input [31:0] data_in,
    output [31:0] data_out
);

    reg [31: 0] Mem[0: 63];

    assign data_out = (memread) ? (Mem[addr/4]): 32'b0;

    initial begin
        Mem[0]=32'd17;
        Mem[1]=32'd9;
        Mem[2]=32'd25;
    
    end

    always@(posedge clk)begin
        if(memwrite == 1)
            Mem[addr/4] = data_in;
    end

endmodule