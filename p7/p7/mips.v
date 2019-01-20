`timescale 1ns / 1ps
`include "head.v"
module mips(clk,reset);
input clk;
input reset;
wire [31:0] t_addr,t_wd,t_rd0,t_rd1,addrbus,wdbus,pc8_m,bridge_rd,cp0_rd,cp0_epc;
wire t_we,t_int0,t_int1,bridge_we,ismtc0,exlclr,intreq,bd;
wire[4:0] cp0dst,exccode;
wire [5:0] hwint;

CPU cpu(.clk(clk),.clr(reset),
				.bridge_we(bridge_we),.addrbus(addrbus),.wdbus(wdbus),.ismtc0(ismtc0),
				.exlclr(exlclr),.cp0dst(cp0dst),.pc8_m(pc8_m),.bd(bd),.exccode(exccode),
				.bridge_rd(bridge_rd),.cp0_rd(cp0_rd),.intreq(intreq),.cp0_epc(cp0_epc));
				
Bridge bridge(.we(bridge_we&~intreq),.addrbus(addrbus),.wdbus(wdbus),.bridge_rd(bridge_rd),.hwint(hwint),
		.t_addr(t_addr),.t_wd(t_wd),.t_we(t_we),.t_rd0(t_rd0),.t_rd1(t_rd1),.t_int0(t_int0),.t_int1(t_int1));
		
CP0 cp0(.clk(clk),.clr(reset),.a1(cp0dst),.a2(cp0dst),.wdbus(wdbus),.pc8_m(pc8_m),.bdin(bd),.hwint(hwint),
	.exccodein(exccode),.we(ismtc0),.exlclr(exlclr),.cp0_rd(cp0_rd),.cp0_epc(cp0_epc),.intreq(intreq));
	
timer                timer0(.clk(clk),.reset(reset),.addr(t_addr),.we(t_we),.wd(t_wd),.rd(t_rd0),.irq(t_int0));
timer #(32'h00007f10)timer1(.clk(clk),.reset(reset),.addr(t_addr),.we(t_we),.wd(t_wd),.rd(t_rd1),.irq(t_int1));
endmodule
