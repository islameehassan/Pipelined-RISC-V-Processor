
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
    
    /*initial begin
        Mem[0]=32'd1;
        Mem[1]=32'd2;
        Mem[2]=32'd0;
        Mem[3]=32'd4;
        Mem[4]=32'd5;
        Mem[5]=32'd6;
        Mem[6]=32'd0;
        Mem[7] = 32'd4;
    end*/

    always@(posedge clk)begin
        if(memwrite == 1)
            Mem[addr/4] = data_in;
    end

endmodule