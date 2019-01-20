`timescale 1ns / 1ps

module Dpipe (clk,clr,en,
				instr_i,pc8_i,
				instr_d,pc8_d);
input clk,clr,en;
input [31:0] instr_i,pc8_i;
output reg [31:0]instr_d,pc8_d;

initial begin
	instr_d<=0; pc8_d<=0;
end

always@(posedge clk)
	begin
		if(clr)
			begin
				instr_d<=0; pc8_d<=0;
			end
		else if(en)
			begin
				instr_d<=instr_d; pc8_d<=pc8_d;
			end
		else 
			begin
				instr_d<=instr_i; pc8_d<=pc8_i;
			end
	end
endmodule
