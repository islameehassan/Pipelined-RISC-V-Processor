`include "RCA.v"


module ALU#(parameter N = 32)(
    input [N - 1: 0] A,
    input [N - 1: 0] B,
    input [3:0] sel,
    output reg [N - 1: 0]ALUOutput,
    output ZeroFlag
);


    wire [N - 1:0] Bnew;
    wire [N - 1: 0] result;
    assign Bnew = (sel[2])? (~B + 1): (B);

    RCA #(.N(N))rca_inst(A, Bnew, result);

    always@(*)begin
    case (sel)
        4'b0000: ALUOutput = A & B;
        4'b0001: ALUOutput = A | B;
        4'b0010: ALUOutput = result;
        4'b0110: ALUOutput = result;
        default: ALUOutput = 0;  
    endcase
    end

    assign ZeroFlag = (ALUOutput == 0);

endmodule