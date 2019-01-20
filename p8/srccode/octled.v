`timescale 1ns / 1ps

module octled(digital_tube0,digital_tube1,digital_tube2,
              sel0,sel1,sel2,
				  clk,clr,t_addr,t_we,t_wd,octled_rd);
output [7:0] digital_tube0,digital_tube1,digital_tube2;
input clk,clr,t_we;
input [31:0]t_addr,t_wd;
output [31:0] octled_rd;
output [3:0] sel0,sel1;
output sel2;

reg [9:0] cnt;
reg [35:0] data;
assign sel0=(clr)?4'b0000:
				(cnt[9:8]==2'b00)?4'b0001:
				(cnt[9:8]==2'b01)?4'b0010:
				(cnt[9:8]==2'b10)?4'b0100:
				                  4'b1000;
assign sel1=sel0;
assign sel2=(clr)?1'b0:
				1'b1;
assign octled_rd=(t_addr>=32'h7f38 &&t_addr<32'h7f3c)?data[31:0]:
						(t_addr>=32'h7f3c &&t_addr<32'h7f40)?{28'b0,data[3:0]}:
						32'h17231181;


wire [7:0] tmp[17:0];
assign tmp[0]= 8'h81;      assign tmp[8]=8'h80;
assign tmp[1]= 8'hcf ;     assign tmp[9]=8'h84;
assign tmp[2]=	8'h92	;		assign tmp[10]=8'h88;
assign tmp[3]=	8'h86	;		assign tmp[11]=8'he0;
assign tmp[4]=	8'hcc	;		assign tmp[12]=8'hb1;
assign tmp[5]=	8'ha4	;		assign tmp[13]=8'hc2;
assign tmp[6]=	8'ha0	;		assign tmp[14]=8'hb0;
assign tmp[7]=	8'h8f	;		assign tmp[15]=8'hb8;
assign tmp[16]=8'hff;/*no*/ assign tmp[17]=8'hfe;/*-*/

wire [31:0] ndata;
assign ndata=($signed(data[31:0])>=0)?data[31:0]:(~data[31:0])+1;
assign digital_tube0=(sel0==4'b0001)?tmp[ndata[3:0]]:
                      (sel0==4'b0010)?tmp[ndata[7:4]]:
							 (sel0==4'b0100)?tmp[ndata[11:8]]:
							 tmp[ndata[15:12]];
assign digital_tube1=(sel1==4'b0001)?tmp[ndata[19:16]]:
                      (sel1==4'b0010)?tmp[ndata[23:20]]:
							 (sel1==4'b0100)?tmp[ndata[27:24]]:
							 tmp[ndata[31:28]];
assign digital_tube2=/*tmp[data[35:32]];*/
							$signed(data[31:0])>=0?tmp[16]:tmp[17];
always @(posedge clk)
	begin
	if(clr)
		begin
			data<=36'b0;
			cnt<=10'b0;
		end
	else
		begin
			cnt<=cnt+1;
			if(t_we&& (t_addr>=32'h7f38 && t_addr<=32'h7f3f))
				begin
					if (t_addr>=32'h7f38 &&t_addr<32'h7f3c)
						data[31:0]<=t_wd;
					else
						data[35:32]<=t_wd[3:0];
				end
		end
	end

endmodule
