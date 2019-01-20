`timescale 1ns / 1ps

module leddriver(clk,clr,led_rd,t_wd,t_we,addr,led_light);
input clk,clr,t_we;
output [31:0]led_rd,led_light;
input [31:0] t_wd,addr;
reg [31:0] tmp;

assign led_light= tmp;
assign led_rd=tmp;

always @(posedge clk)
	begin
		if(clr)
			tmp<=32'hffffffff;
		else if(t_we==1 && addr==32'h00007f34)
			begin
				tmp<=~t_wd;
			end
	end


endmodule
