

module ControlUnit(
    input [4: 0]inst,
    output reg branch, memread, memtoreg, memwrite, alusrc, regwrite,
    output reg [1: 0] aluop
);

    always@(*)begin
        // R-Format
        if(inst == 5'b01100)begin
            branch = 0;
            memread = 0;
            memtoreg = 0;
            aluop = 2'b10;
            memwrite = 0;
            alusrc = 0;
            regwrite = 1;
        end
        // LW
        else if(inst == 5'b00000)begin
            branch = 0;
            memread = 1;
            memtoreg = 1;
            aluop = 2'b00;
            memwrite = 0;
            alusrc = 1;
            regwrite = 1;
        end
        // SW
        if(inst == 5'b01000)begin
            branch = 0;
            memread = 0;
            memtoreg = 1; // donot care
            aluop = 2'b00;
            memwrite = 1;
            alusrc = 1;
            regwrite = 0;
        end
        // BEQ
        else if(inst == 5'b11000)begin
            branch = 1;
            memread = 0;
            memtoreg = 1; // donot care
            aluop = 2'b01;
            memwrite = 0;
            alusrc = 0;
            regwrite = 0;
        end
    end
endmodule