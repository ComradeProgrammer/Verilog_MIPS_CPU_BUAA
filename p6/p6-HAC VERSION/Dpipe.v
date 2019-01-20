`timescale 1ns / 1ps

module Dpipe (clk,clr,en,npcout,iseret,
				instr_i,pc8_i,bd_i,exccode_i,
				instr_d,pc8_d,bd_d,exccode_d);
input clk,clr,en,bd_i,iseret;
input [31:0] instr_i,pc8_i,npcout;
input[4:0] exccode_i;
output reg [31:0]instr_d,pc8_d;
output reg bd_d;
output reg[4:0] exccode_d; 

initial begin
	instr_d<=0; pc8_d<=32'h00003008;exccode_d<=0;bd_d<=0;
end

always@(posedge clk)
	begin
		if(clr)
			begin
				instr_d<=0; pc8_d<=32'h00003008;exccode_d<=0;bd_d<=0;
			end
		else if(iseret)
			begin
				instr_d<=0; pc8_d<=npcout+8;exccode_d<=0;bd_d<=0;
			end
		else if(en)
			begin
				instr_d<=instr_d; pc8_d<=pc8_d;bd_d<=bd_d;exccode_d<=exccode_d;
			end
		else 
			begin
				instr_d<=instr_i; pc8_d<=pc8_i;bd_d<=bd_i;exccode_d<=exccode_i;
			end
	end
endmodule
