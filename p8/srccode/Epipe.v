`timescale 1ns / 1ps

module Epipe(clk,clr,stall,
res_d,instr_d,a1_d,a2_d,a3_d,v1_d,v2_d,oth_d,pc8_d,bd_d,exccode_d,
res_e,instr_e,a1_e,a2_e,a3_e,v1_e,v2_e,oth_e,pc8_e,bd_e,exccode_e);
input clk,clr,stall,bd_d;
input [2:0] res_d;
input [31:0] instr_d,v1_d,v2_d,oth_d,pc8_d;
input [4:0] a1_d,a2_d,a3_d,exccode_d;
output reg[2:0] res_e;
output reg[31:0] instr_e,v1_e,v2_e,oth_e,pc8_e;
output reg [4:0] a1_e,a2_e,a3_e,exccode_e;
output reg bd_e;

/*initial begin
	res_e<=0;
	instr_e<=0; v1_e<=0; v2_e<=0; oth_e<=0; pc8_e<=32'h00003008;
	a1_e<=0;a2_e<=0;a3_e<=0;
	bd_e<=0;exccode_e<=0;
end
*/
always @(posedge clk)
begin
	if (clr)
		begin
			res_e<=0;
			instr_e<=0; v1_e<=0; v2_e<=0; oth_e<=0; pc8_e<=32'h00003008;
			a1_e<=0;a2_e<=0;a3_e<=0;
			bd_e<=0;exccode_e<=0;
		end
	else if(stall)
		begin
			res_e<=0;
			instr_e<=0; v1_e<=0; v2_e<=0; oth_e<=0; pc8_e<=pc8_d;
			a1_e<=0;a2_e<=0;a3_e<=0;
			bd_e<=bd_d; exccode_e<=0;
		end
	else 
		begin
			res_e<=res_d;
			instr_e<=instr_d; v1_e<=v1_d; v2_e<=v2_d; oth_e<=oth_d; pc8_e<=pc8_d;
			a1_e<=a1_d;a2_e<=a2_d;a3_e<=a3_d;
			bd_e<=bd_d;exccode_e<=exccode_d;
		end
end

endmodule
