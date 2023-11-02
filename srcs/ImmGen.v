
module ImmGen(
	input[31: 0] inst,
	output reg [31: 0] gen_out
);

	always@(*)
	begin
		gen_out = 0;
		// LW and SW 
		if(inst[6] == 0)begin
			// LW 
			if(inst[5] == 0)begin
				gen_out = {{20{inst[31]}},inst[31:20]};
			end
			else begin
			// SW
				gen_out = {{20{inst[31]}},inst[31:25], inst[11:7]};
			end
		end
		// BEQ
		else begin 
		gen_out = {{20{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8]};
		end
	end
endmodule