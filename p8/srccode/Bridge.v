`timescale 1ns / 1ps
module Bridge(we,addrbus,wdbus,bridge_rd,hwint,t_addr,t_wd,t_we,
t_rd0,t_int0,
uart_rd,uart_int,stb,
switch_rd,switch_int,
led_rd,
tube8_rd,
userkey_rd,userkey_int
);
input we,t_int0,uart_int,switch_int,userkey_int;
input [31:0] addrbus,wdbus,t_rd0,uart_rd,switch_rd,led_rd,tube8_rd,userkey_rd;
output t_we,stb;
output [31:0]bridge_rd,t_addr,t_wd;
output [5:0] hwint;

assign t_addr=addrbus;
assign t_we=we;
assign t_wd=wdbus;
//assign hwint={4'b0,t_int1,t_int0};

/*assign bridge_rd=(addrbus>=32'h00007f00&&addrbus<=32'h00007f0b)?t_rd0:
						(addrbus>=32'h00007f10&&addrbus<=32'h00007f1b)?t_rd1:
						32'h17230000;*/
assign hwint={userkey_int,2'b0,switch_int,uart_int,t_int0};
assign bridge_rd=(addrbus>=32'h00007f00&&addrbus<=32'h00007f0b)?t_rd0:
					  (addrbus>=32'h00007f10&&addrbus<=32'h00007f2b)?uart_rd:
					  (addrbus>=32'h00007f2c&&addrbus<=32'h00007f33)?switch_rd:
					  (addrbus>=32'h00007f34&&addrbus<=32'h00007f37)?led_rd:
					  (addrbus>=32'h00007f38&&addrbus<=32'h00007f3f)?tube8_rd:
					  (addrbus>=32'h00007f40&&addrbus<=32'h00007f43)?userkey_rd:
					  32'h1723ffff;
assign stb=	(addrbus>=32'h00007f10&&addrbus<=32'h00007f2b);				  

endmodule
