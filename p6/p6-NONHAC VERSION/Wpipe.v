`timescale 1ns / 1ps

module Wpipe(clk,clr,
res_m,instr_m,a3_m,ao_m,dr_m,pc8_m,
res_w,instr_w,a3_w,ao_w,dr_w,pc8_w);
input clk,clr;
input [2:0] res_m;
input [4:0] a3_m;
input [31:0] instr_m,ao_m,dr_m,pc8_m;
output reg[2:0] res_w;
output reg[4:0] a3_w;
output reg[31:0] instr_w,ao_w,dr_w,pc8_w;

initial begin
	res_w<=0;
	a3_w<=0;
	instr_w<=0;ao_w<=0;dr_w<=0;pc8_w<=0;
end

always @(posedge clk)
begin
	if(clr)
		begin
			res_w<=0;
			a3_w<=0;
			instr_w<=0;ao_w<=0;dr_w<=0;pc8_w<=0;
		end
	else
		begin
			res_w<=res_m;
			a3_w<=a3_m;
			instr_w<=instr_m;ao_w<=ao_m;dr_w<=dr_m;pc8_w<=pc8_m;
		end
end

endmodule
