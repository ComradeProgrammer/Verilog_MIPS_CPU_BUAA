`timescale 1ns / 1ps

module Mpipe(clk,clr,
res_e,instr_e,a2_e,a3_e,v2_e,ao_e,pc8_e,bd_e,exccode_e,
res_m,instr_m,a2_m,a3_m,v2_m,ao_m,pc8_m,bd_m,exccode_m);
input clk,clr,bd_e;
input [2:0] res_e;
input [4:0] a2_e,a3_e,exccode_e;
input [31:0] instr_e,v2_e,ao_e,pc8_e;
output reg [2:0] res_m;
output reg [4:0] a2_m,a3_m,exccode_m;
output reg [31:0] instr_m,v2_m,ao_m,pc8_m;
output reg bd_m;

/*initial begin
	res_m<=0;
	a2_m<=0;a3_m<=0;
	instr_m<=0;v2_m<=0;ao_m<=0;pc8_m<=32'h3008;
	bd_m<=0;exccode_m<=0;
end
*/
always @(posedge clk)
begin
	if (clr)
		begin
			res_m<=0;
			a2_m<=0;a3_m<=0;
			instr_m<=0;v2_m<=0;ao_m<=0;pc8_m<=32'h3008;
			bd_m<=0;exccode_m<=0;
		end
	else
		begin
			res_m<=res_e;
			a2_m<=a2_e;a3_m<=a3_e;
			instr_m<=instr_e;v2_m<=v2_e;ao_m<=ao_e;pc8_m<=pc8_e;
			bd_m<=bd_e;exccode_m<=exccode_e;
		end
end

endmodule
