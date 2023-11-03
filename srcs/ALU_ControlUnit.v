
module ALU_ControlUnit(
    input [1: 0] aluop,
    input [2: 0] func3,
    input func7bit,
    output reg [3: 0] alusel
);


    always@(*)begin
        // ADD
        if(aluop == 2'b00 || (aluop == 2'b10 && func3 == 3'b000 && func7bit == 0))begin
            alusel = 4'b0010; 
        end
        // SUB
        else if(aluop == 2'b01 || (aluop == 2'b10 && func3 == 3'b000 && func7bit == 1))begin
            alusel = 4'b0110; 
        end
        // AND & OR
        else if(aluop == 2'b10)begin
            /// AND
            if(func3 == 3'b111)
                alusel = 4'b0000;
            // OR
            else if(func3 == 3'b110)
                alusel = 4'b0001; 
        end
        else
            alusel = 4'b1111; // No operation
    end
endmodule


           /*  
           // arithmetic
            4'b00_00 : r = add;
            4'b00_01 : r = add;
            4'b00_11 : r = b;
            // logic
            4'b01_00:  r = a | b;
            4'b01_01:  r = a & b;
            4'b01_11:  r = a ^ b;
            // shift
            4'b10_00:  r=sh;
            4'b10_01:  r=sh;
            4'b10_10:  r=sh;
            // slt & sltu
            4'b11_01:  r = {31'b0,(sf != vf)}; 
            4'b11_11:  r = {31'b0,(~cf)};  
            */