`timescale 1ns / 1ps
`include"head.v"
module Exc_m(instr_m,ao_m,exccode_e,bd_e,exccode_m,bd_m);
input [31:0] instr_m,ao_m;
input [4:0] exccode_e;
input bd_e;
output reg [4:0] exccode_m;
output bd_m;

wire [5:0] op,funct;
assign funct=instr_m[5:0];
assign op=instr_m[31:26];

assign bd_m=bd_e;

initial begin
	exccode_m<=0;
end

always@(*)
	begin
		if(op==`lw)
			begin
				if(ao_m[1:0]!=0)
					exccode_m<=`exc_adel;
				else if(ao_m>32'h2ffe&&!(ao_m>=32'h7f00&&ao_m<=32'h7f0b||ao_m>=32'h7f10&&ao_m<=32'h7f1b))
					exccode_m<=`exc_adel;
				else
					exccode_m<=exccode_e;
			end
		else if(op==`sw)
			begin
				if(ao_m[1:0]!=0)
					exccode_m<=`exc_ades;
				else if(ao_m>32'h2ffe&&!(ao_m>=32'h7f00&&ao_m<=32'h7f07||ao_m>=32'h7f10&&ao_m<=32'h7f17))
					exccode_m<=`exc_ades;
				else
					exccode_m<=exccode_e;
			end
		else
			exccode_m<=exccode_e;
	end



endmodule
