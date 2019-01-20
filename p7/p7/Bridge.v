`timescale 1ns / 1ps
module Bridge(we,addrbus,wdbus,bridge_rd,hwint,t_addr,t_wd,t_we,t_rd0,t_rd1,t_int0,t_int1);
input we,t_int0,t_int1;
input [31:0] addrbus,wdbus,t_rd0,t_rd1;
output t_we;
output [31:0]bridge_rd,t_addr,t_wd;
output [5:0] hwint;

assign t_addr=addrbus;
assign t_we=we;
assign t_wd=wdbus;
assign hwint={4'b0,t_int1,t_int0};

assign bridge_rd=(addrbus>=32'h00007f00&&addrbus<=32'h00007f0b)?t_rd0:
						(addrbus>=32'h00007f10&&addrbus<=32'h00007f1b)?t_rd1:
						32'h17230000;


endmodule
