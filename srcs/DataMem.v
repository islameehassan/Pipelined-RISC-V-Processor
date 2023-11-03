`include "include/defines.v"

module DataMem(
    input clk,
    input memread, memwrite,
    input func3,
    input [32:0] addr,
    input [31:0] data_in,
    output reg [31:0] data_out
);

    reg [7: 0] Mem[0: 255];
    //reg [31: 0] Mem[0: 63];       // Old
    // Mem[addr:arr+3], Mem[addr: addr + 0], Mem[0:addr+1]


     /* case (func3)
        `F3_LB : data_out = (memread) ? ({{24{Mem[addr][7]}}, Mem[addr]}): 32'b0;               //LB
        `F3_LH : data_out = (memread) ? ({{16{Mem[addr+1 +: 0][7]}}, Mem[addr +: 1]}): 32'b0;    //LH
        `F3_LW : data_out = (memread) ? ({Mem[addr +: 3]}): 32'b0;                         //LW
        `F3_LBU : data_out = (memread) ? ({24'b0, Mem[addr]}): 32'b0;                           //LBU
        `F3_LHU : data_out = (memread) ? ({16'b0, Mem[addr +: 1]}): 32'b0;                 //LHU     	
    endcase */

    always @ * begin
        if (memread == 1) begin
            case (func3)
                `F3_LB_SB : data_out = {{24{Mem[addr][7]}}, Mem[addr]};               //LB
                `F3_LH_SH : data_out = {{16{Mem[addr+1 +: 0][7]}}, Mem[addr +: 1]};   //LH
                `F3_LW_SW : data_out = {Mem[addr +: 3]};                              //LW
                `F3_LBU : data_out = {24'b0, Mem[addr]};                              //LBU
                `F3_LHU : data_out = {16'b0, Mem[addr +: 1]};                         //LHU     	
            endcase
        end
        else
            data_out = 32'b0;
    end
    // assign data_out = (memread) ? (Mem[addr/4]): 32'b0;      // Old

    /* Lab6 Test Case using byte-adressable memory
    initial begin
        Mem[0]=8'b0001_0001;
        Mem[1]=8'b0000_0000;
        Mem[2]=8'b0000_0000;
        Mem[3]=8'b0000_0000;
        Mem[4]=8'b0000_1001;
        Mem[5]=8'b0000_0000;
        Mem[6]=8'b0000_0000;
        Mem[7]=8'b0000_0000;
        Mem[8]=8'b0001_1001;
        Mem[9]=8'b0000_0000;
        Mem[10]=8'b0000_0000;
        Mem[11]=8'b0000_0000;
    end */
    
    initial begin
        Mem[0] = 8'b0;
        Mem[1] = 8'b0;
        Mem[2] = 8'b0;
        Mem[3] = 8'b0;
        Mem[4] = 8'b0;
        Mem[5] = 8'b0;
        Mem[6] = 8'b0;
        Mem[7] = 8'b0;
        Mem[8] = 8'b0;
        Mem[9] = 8'b0;
        Mem[10] = 8'b0;
        Mem[11] = 8'b0;
        Mem[12] = 8'b0;
        Mem[13] = 8'b0;
        Mem[14] = 8'b0;
        Mem[15] = 8'b0;
        Mem[16] = 8'b0;
        Mem[17] = 8'b0;
        Mem[18] = 8'b0;
        Mem[19] = 8'b0;
        Mem[20] = 8'b0;
        Mem[21] = 8'b0;
        Mem[22] = 8'b0;
        Mem[23] = 8'b0;
    end



    /* Data for a test case
    initial begin
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
        if(memwrite == 1) begin
            case (func3)
                `F3_LB_SB : Mem[addr] = data_in[7:0];                    //SB
                `F3_LH_SH : {Mem[addr+1], Mem[addr]} =  data_in[15:0];   //SH
                `F3_LW_SW : Mem[addr +: 4] = data_in;                    //SW   	
            endcase
        end
    end

    //Mem[addr/4] = data_in;    // Old

endmodule