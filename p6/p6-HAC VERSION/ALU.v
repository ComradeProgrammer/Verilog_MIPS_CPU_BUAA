`timescale 1ns / 1ps

module ALU(a,b,aluop,ao,overflow);
input [31:0] a,b;
input [2:0] aluop;
output [31:0] ao;//เปฃก
output overflow;

wire [31:0] tmp[7:0];
assign tmp[0]=b;
assign tmp[1]=a+b;
assign tmp[2]=a-b;
assign tmp[3]=a|b;
assign tmp[4]=a&b;
assign ao=tmp[aluop]; 
wire [32:0] temp1,temp2;


assign temp1={a[31],a}+{b[31],b};
assign temp2={a[31],a}-{b[31],b};
//assign overflow=(aluop==1&&($signed(temp1)!=$signed(ao)))||(aluop==2&&($signed(temp2)!=$signed(ao)));
/* assign overflow=(aluop==1&&$signed(a)>0&&$signed(b)>0&&$signed(ao)<0)
		||(aluop==1&&$signed(a)<0&&$signed(b)<0&&$signed(ao)>0)
		||(aluop==2&&$signed(a)>0&&$signed(b)<0&&$signed(ao)<0)
		||(aluop==2&&$signed(a)<0&&$signed(b)>0&&$signed(ao)>0);*/
assign overflow =((aluop==1)&&(temp1[32]!=temp1[31]))||((aluop==2)&&(temp2[32]!=temp2[31]));
endmodule
