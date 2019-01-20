`timescale 1ns / 1ps
`include "head.v"
module mips(clk_in,reset,rx,tx,
                    dip_switch0,dip_switch1,dip_switch2,dip_switch3,
						  dip_switch4,dip_switch5,dip_switch6,dip_switch7,
				user_key,led_light,
				digital_tube0,digital_tube1,digital_tube2,
				sel0,sel1,sel2);
input clk_in;
input reset;
input rx;
output tx;
input [7:0] dip_switch0,dip_switch1,dip_switch2,dip_switch3,
				dip_switch4,dip_switch5,dip_switch6,dip_switch7,
				user_key;
output [31:0]led_light;
output [7:0] digital_tube0,digital_tube1,digital_tube2;
output [3:0] sel0,sel1;
output sel2;

wire [31:0] t_addr,t_wd,t_rd0,t_rd1,addrbus,wdbus,pc8_m,bridge_rd,cp0_rd,cp0_epc;
wire t_we,t_int0,t_int1,bridge_we,ismtc0,exlclr,intreq,bd;
wire[4:0] cp0dst,exccode;
wire [5:0] hwint;
wire clk1,clk2;

wire [31:0] uart_rd;
wire stb;
wire [31:0] switch_rd;
wire switch_int;
wire [31:0] userkey_rd;
wire userkey_int;
wire [31:0]led_rd;
wire [31:0] octled_rd;
clock instance_name
   (// Clock in ports
    .CLK_IN1(clk_in),      // IN
    // Clock out ports
    .CLK_OUT1(clk1),     // OUT
    .CLK_OUT2(clk2));    // OUT


CPU cpu(.clk1(clk1),.clk2(clk2),.clr(reset),
				.bridge_we(bridge_we),.addrbus(addrbus),.wdbus(wdbus),.ismtc0(ismtc0),
				.exlclr(exlclr),.cp0dst(cp0dst),.pc8_m(pc8_m),.bd(bd),.exccode(exccode),
				.bridge_rd(bridge_rd),.cp0_rd(cp0_rd),.intreq(intreq),.cp0_epc(cp0_epc));
				

		
CP0 cp0(.clk(clk1),.clr(reset),.a1(cp0dst),.a2(cp0dst),.wdbus(wdbus),.pc8_m(pc8_m),.bdin(bd),.hwint(hwint),
	.exccodein(exccode),.we(ismtc0),.exlclr(exlclr),.cp0_rd(cp0_rd),.cp0_epc(cp0_epc),.intreq(intreq));
	
//===========================devices&&bridges==========================================================
Bridge bridge(.we(bridge_we&~intreq),.addrbus(addrbus),.wdbus(wdbus),.bridge_rd(bridge_rd),.hwint(hwint),
		.t_addr(t_addr),.t_wd(t_wd),.t_we(t_we),.t_rd0(t_rd0),.t_int0(t_int0),
		.uart_rd(uart_rd),.uart_int(uart_int),.stb(stb),
		.switch_rd(switch_rd),.switch_int(switch_int),
		.userkey_rd(userkey_rd),.userkey_int(userkey_int),
		.led_rd(led_rd),
		.tube8_rd(octled_rd));
	
timer  timer0(.clk(clk1),.reset(reset),.addr(t_addr),.we(t_we),.wd(t_wd),.rd(t_rd0),.irq(t_int0));
MiniUART uart( .ADD_I(t_addr[4:2]-3'b100), .DAT_I(t_wd), .DAT_O(uart_rd), .STB_I(stb), .WE_I(t_we), .CLK_I(clk1), .RST_I(reset), .RxD(rx), .TxD(tx) ,.uartint(uart_int)) ;
switchdriver switch(dip_switch0,dip_switch1,dip_switch2,dip_switch3,
						  dip_switch4,dip_switch5,dip_switch6,dip_switch7,
						  clk1,reset,t_addr,switch_rd,switch_int);
userkeydriver userkey(.clk(clk1),.clr(reset),.user_key(user_key),.userkey_rd(userkey_rd),.userkey_int(userkey_int));
leddriver led(.clk(clk1),.clr(reset),.led_rd(led_rd),.t_wd(t_wd),.t_we(t_we),.addr(t_addr),.led_light(led_light));
octled octleds(.digital_tube0(digital_tube0),.digital_tube1(digital_tube1),.digital_tube2(digital_tube2),
					.sel0(sel0),.sel1(sel1),.sel2(sel2),
				  .clk(clk1),.clr(reset),.t_addr(t_addr),.t_we(t_we),.t_wd(t_wd),.octled_rd(octled_rd));
endmodule
