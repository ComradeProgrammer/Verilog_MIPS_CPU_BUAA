`timescale 1ns / 1ps

module switchdriver(dip_switch0,dip_switch1,dip_switch2,dip_switch3,
						  dip_switch4,dip_switch5,dip_switch6,dip_switch7,
						  clk,reset,addr,switch_rd,switch_int);
input [7:0]dip_switch0,dip_switch1,dip_switch2,dip_switch3,
						  dip_switch4,dip_switch5,dip_switch6,dip_switch7;
input[31:0] addr;						  
input clk,reset;
output [31:0]switch_rd ;
output reg switch_int;

reg [63:0]  oldin;
wire [63:0] in;

assign in=~{dip_switch7,dip_switch6,dip_switch5,dip_switch4,dip_switch3,dip_switch2,dip_switch1,dip_switch0};
assign switch_rd=(addr==32'h00007f2c)?in[31:0]:
					(addr==32'h00007f30)?in[63:32]:
					32'h1723fffe;
always @(posedge clk)
	begin
		if(reset)
			begin
				oldin<=64'h0;
				switch_int<=0;
			end
		else
			begin
				oldin<=in;
				if (oldin==in)
					switch_int<=0;
				else
					switch_int<=1;
			end
	end

endmodule
