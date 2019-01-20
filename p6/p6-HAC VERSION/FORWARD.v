`timescale 1ns / 1ps
`include "head.v"
module FORWARD(abus,resbus,forwardbus);
input [39:0] abus;
input [8:0] resbus;
output [12:0] forwardbus;

wire [4:0] a1_d,a2_d,a1_e,a2_e,a2_m,a3_e,a3_m,a3_w;
assign a1_d=abus[4:0];
assign a2_d=abus[9:5];
assign a1_e=abus[14:10];
assign a2_e=abus[19:15];
assign a2_m=abus[24:20];
assign a3_e=abus[29:25];
assign a3_m=abus[34:30];
assign a3_w=abus[39:35];

wire[2:0] res_e,res_m,res_w;
assign res_e=resbus[2:0];
assign res_m=resbus[5:3];
assign res_w=resbus[8:6];

wire [2:0] fv1dctrl,fv2dctrl,faluaectrl,falubectrl;
wire fdmmctrl;
assign forwardbus[2:0]=fv1dctrl;
assign forwardbus[5:3]=fv2dctrl;
assign forwardbus[8:6]=faluaectrl;
assign forwardbus[11:9]=falubectrl;
assign forwardbus[12]=fdmmctrl;

assign fv1dctrl=(res_e==`pc && a1_d==a3_e && a1_d!=0)?`fd_pc8_e:
					 (res_e==`other && a1_d==a3_e &&a1_d!=0)?`fd_oth_e:
					 (res_m==`alu && a1_d==a3_m && a1_d!=0)?`fd_ao_m:
					 (res_m==`pc && a1_d==a3_m && a1_d!=0)?`fd_pc8_m:
					 `fd_rd;
assign fv2dctrl=(res_e==`pc && a2_d==a3_e && a2_d!=0)?`fd_pc8_e:
					 (res_e==`other && a2_d==a3_e &&a2_d!=0)?`fd_oth_e:
					 (res_m==`alu && a2_d==a3_m && a2_d!=0)?`fd_ao_m:
					 (res_m==`pc && a2_d==a3_m && a2_d!=0)?`fd_pc8_m:
					 `fd_rd;
assign faluaectrl=(res_m==`pc &&a1_e==a3_m&&a1_e!=0)?`falue_pc8_m:
					   (res_m==`alu &&a1_e==a3_m&&a1_e!=0)?`falue_ao_m:
						(res_w!=`nw && a1_e==a3_w&&a1_e!=0)?`falue_wd_w:
						`falue_v;
assign falubectrl=(res_m==`pc &&a2_e==a3_m&&a2_e!=0)?`falue_pc8_m:
					   (res_m==`alu &&a2_e==a3_m&&a2_e!=0)?`falue_ao_m:
						(res_w!=`nw && a2_e==a3_w&&a2_e!=0)?`falue_wd_w:
						`falue_v;
assign fdmmctrl=(res_w!=`nw && a2_m==a3_w &&a2_m!=0)?1:0;											




endmodule
