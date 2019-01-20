`timescale 1ns / 1ps
`include "head.v"
module multdiv(clk,clr,a,b,a1,start,mode,we,busy,hi,lo);
input [31:0] a,b;
input  a1;
input start,we,clk,clr;
input  [1:0] mode;
output reg busy ;
output reg [31:0] hi,lo;

reg [31:0] hitmp,lotmp;
reg [4:0] state,count;

initial begin
 state=0; count=0; hitmp=0;lotmp=0;hi<=0;lo<=0;busy<=0;
end
always @(negedge clk)
	begin
		if(start==1&&state==0)
			begin
				state<=1;
			
				if(mode==`md_mult)
					begin
						{hitmp,lotmp}<=$signed(a)*$signed(b);
						count<=5;
					end
				else if(mode==`md_multu)
					begin
						{hitmp,lotmp}<=$unsigned(a)*$unsigned(b);
						count<=5;
					end
				else if(mode==`md_div)
					begin
						hitmp<=$signed(a)%$signed(b);
						lotmp<=$signed(a)/$signed(b);
							count<=10;
					end
				else if(mode==`md_divu)
					begin
						hitmp<=$unsigned(a)%$unsigned(b);
						lotmp<=$unsigned(a)/$unsigned(b);
							count<=10;
					end
			end
	end
always@(posedge clk)
	begin
		if (clr)
			begin
				state=0; count=0; hitmp=0;lotmp=0;hi<=0;lo<=0;
			end
		
		else if(state==1&&count!=0)
		begin
			count<=count-1;
			busy<=1;
		end
		else if(state==1&&count==0)
			begin
				{hi,lo}<={hitmp,lotmp};
				state<=0;
				busy<=0;
			end
		else if(state==0&&we==1)
			begin
				if(a1==0)
					lo<=a;
				else if(a1==1)
					hi<=a;
			end
		else
		     ;

	end


endmodule
