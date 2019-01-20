`timescale 1ns / 1ps

module DM(clk,clr,we,addr,wd,dmout,hf,bt);
input clk,clr,we,hf,bt;
input [31:0] addr,wd;
output [31:0]dmout;

reg [31:0] dmmem[1023:0];
integer i;
wire [31:0] word,wdin;
wire [31:0] hfword[1:0],hfin[1:0];
wire [31:0]btword[3:0],btin[3:0];



assign word=dmmem[addr[11:2]];
assign hfword[0]={16'b0,word[15:0]};
assign hfword[1]={16'b0,word[31:16]};
assign btword [0]={24'b0,word[7:0]};
assign btword [1]={24'b0,word[15:8]};
assign btword [2]={24'b0,word[23:16]};
assign btword [3]={24'b0,word[31:24]};


assign hfin[0]={word[31:16],wd[15:0]};
assign hfin[1]={wd[15:0],word[15:0]};
assign btin[0]={word[31:24],word[23:16],word[15:8],wd[7:0]};
assign btin[1]={word[31:24],word[23:16],wd[7:0],word[7:0]};
assign btin[2]={word[31:24],wd[7:0],word[15:8],word[7:0]};
assign btin[3]={wd[7:0],word[23:16],word[15:8],word[7:0]};

assign wdin=(hf==1)?hfin[addr[1]]:
				(bt==1)?btin[addr[1:0]]:
				wd;

initial begin
	for(i=0;i<1024;i=i+1)
		dmmem[i]<=0;
end


always@(posedge clk)
	begin
		if(clr)
			begin
				for(i=0;i<1024;i=i+1)
					dmmem[i]<=0;
			end
		else
			begin
				if(we)
					begin
						dmmem[addr[11:2]]<=wdin;
						$display("@%h: *%h <= %h",im.pc, {addr[31:2],2'b00},wdin);//xian fang zheli
					end
			end
	end


assign dmout=(hf==1)?hfword[addr[1]]:
					(bt==1)?btword[addr[1:0]]:
					word;
endmodule
