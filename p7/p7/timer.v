`timescale 1ns / 1ps
`define idle 0
`define load 1
`define cnting 2
`define intrpt 3
module timer(clk,reset,addr,we,wd,rd,irq);
input clk,reset,we;
input [31:0] addr,wd;
output [31:0]rd;
output irq;

parameter address=32'h00007f00;
reg [31:0] ctrl,preset,count;
reg [2:0] state;
wire [3:0]add;
reg ir;
assign add=addr[3:0]; 
assign irq=ir&ctrl[3];

assign rd=(add==0)?ctrl:
			 (add==4)?preset:
			 (add==8)?count:
			 32'hf0f0f0f0;

initial begin
	ctrl<=0; preset<=0; count<=0;
	state<=`idle; ir<=0;
end
always @(posedge clk)
	begin
		if(reset)
			begin
				ctrl<=0; preset<=0; count<=0;
				state<=`idle; ir<=0;
			end
		else if(we==1&&reset==0&&addr[31:4]==address[31:4])
			begin
				if(add==0)
					ctrl<=wd;
				else if(add==4)
					preset<=wd;
			end
		
		else if(state==`idle)
			begin
				if(ctrl[0]==1)
					begin
						ir<=0;
						state<=`load;
					end
			end
		
		else if(state==`load)
			begin
				count<=preset;
				state<=`cnting;
			end
			
		else if(state==`cnting)
			begin
				if(ctrl[0]==0)
					state<=`idle;
				else if(ctrl[0]==1 &&count==1)
					begin
						count<=count-1;
						state<=`intrpt;
						if(~(we==1&&reset==0&&addr[31:4]==address[31:4]))
							ctrl[0]<=0;
						ir<=1;
					end	
				else 
					begin
						count<=count-1;
					end
			end
			
		else if(state==`intrpt)
			begin
				if(ctrl[2:1]==1)
					begin
						ir<=0;
						state<=`idle;
						//if(~(we==1&&reset==0&&addr[31:4]==address[31:4]))
							ctrl[0]<=1;
					end
				else
					begin
						state<=`idle;
						
					end
			end
	end
	



endmodule
