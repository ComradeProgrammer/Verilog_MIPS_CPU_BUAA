`timescale 1ns / 1ps

module ALU(a,b,aluop,instr_e,ao,overflow);
input [31:0] a,b;
input [4:0] aluop;
input [31:0] instr_e;
output [31:0] ao;//เปฃก
output overflow;

wire [4:0] shamt;
assign shamt=instr_e[10:6];

wire [31:0] tmp[31:0];
assign tmp[0]=b;
assign tmp[1]=a+b;
assign tmp[2]=a-b;
assign tmp[3]=a|b;
assign tmp[4]=a&b;
assign tmp[5]=$unsigned(b)<<$unsigned(shamt);
assign tmp[6]=$unsigned(b)>>$unsigned(shamt);
assign tmp[7]=$signed(b)>>>$unsigned(shamt);
assign tmp[8]=$unsigned(b)<<$unsigned(a[4:0]);
assign tmp[9]=$unsigned(b)>>$unsigned(a[4:0]);
assign tmp[10]=$signed(b)>>>$unsigned(a[4:0]);
assign tmp[11]=a^b;
assign tmp[12]=~(a|b);
assign tmp[13]=($signed(a)<$signed(b))?32'b1:32'b0;
assign tmp[14]=($unsigned(a)<$unsigned(b))?32'b1:32'b0;


assign ao=tmp[aluop]; 
wire [32:0] temp1,temp2;


assign temp1={a[31],a}+{b[31],b};
assign temp2={a[31],a}-{b[31],b};
assign overflow =((aluop==1)&&(temp1[32]!=temp1[31]))||((aluop==2)&&(temp2[32]!=temp2[31]));
endmodule
