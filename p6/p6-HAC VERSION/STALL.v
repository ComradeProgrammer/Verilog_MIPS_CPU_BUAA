`timescale 1ns / 1ps
`include "head.v"
module STALL(tuse_rs,tuse_rt,resbus,abus,stall);
input [1:0] tuse_rs,tuse_rt;
input [39:0] abus;
input [8:0] resbus;
output stall;

wire [4:0] a1_d,a2_d,a3_e,a3_m,a3_w;
assign a1_d=abus[4:0];
assign a2_d=abus[9:5];
assign a3_e=abus[29:25];
assign a3_m=abus[34:30];
assign a3_w=abus[39:35];

wire[2:0] res_e,res_m,res_w;
assign res_e=resbus[2:0];
assign res_m=resbus[5:3];
assign res_w=resbus[8:6];

wire stall_rs01e,stall_rs02e,stall_rs12e,stall_rs01m;
wire stall_rt01e,stall_rt02e,stall_rt12e,stall_rt01m;
wire stall_rs,stall_rt;

assign stall_rs01e=(tuse_rs==0)&&(res_e==`alu)&&(a1_d==a3_e)&&(a1_d!=0);
assign stall_rs02e=(tuse_rs==0)&&(res_e==`dm)&&(a1_d==a3_e)&&(a1_d!=0);
assign stall_rs12e=(tuse_rs==1)&&(res_e==`dm)&&(a1_d==a3_e)&&(a1_d!=0);
assign stall_rs01m=(tuse_rs==0)&&(res_m==`dm)&&(a1_d==a3_m)&&(a1_d!=0);
assign stall_rs=stall_rs01e|stall_rs02e|stall_rs12e|stall_rs01m;

assign stall_rt01e=(tuse_rt==0)&&(res_e==`alu)&&(a2_d==a3_e)&&(a2_d!=0);
assign stall_rt02e=(tuse_rt==0)&&(res_e==`dm)&&(a2_d==a3_e)&&(a2_d!=0);
assign stall_rt12e=(tuse_rt==1)&&(res_e==`dm)&&(a2_d==a3_e)&&(a2_d!=0);
assign stall_rt01m=(tuse_rt==0)&&(res_m==`dm)&&(a2_d==a3_m)&&(a2_d!=0);
assign stall_rt=stall_rt01e|stall_rt02e|stall_rt12e|stall_rt01m;

assign stall=stall_rs|stall_rt;



endmodule
