`timescale 1ns / 1ps

module DM(clk,clr,be,we,addr,wd,dr);
input clk,clr,we;
input [31:0] addr,wd;
input [3:0] be;
output [31:0]dr;
wire [3:0] newbe;
assign newbe=be&{we,we,we,we};

wire [31:0]dina;
assign dina=(be==4'b0001)?{24'b0,wd[7:0]}:
				(be==4'b0010)?{16'b0,wd[7:0],8'b0}:
				(be==4'b0100)?{8'b0,wd[7:0],16'b0}:
				(be==4'b1000)?{wd[7:0],24'b0}:
				(be==4'b0011)?{16'b0,wd[15:0]}:
				(be==4'b1100)?{wd[15:0],16'b0}:
				wd;


dmdm ddddddmmmmmmm(
  .clka(clk), // input clka
  .wea(newbe), // input [3 : 0] wea
  .addra(addr[14:2]), // input [12 : 0] addra
  .dina(dina), // input [31 : 0] dina
  .douta(dr) // output [31 : 0] douta
);

endmodule
