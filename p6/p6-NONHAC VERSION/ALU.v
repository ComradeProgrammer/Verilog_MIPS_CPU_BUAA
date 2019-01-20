`timescale 1ns / 1ps

module ALU(a,b,aluop,instr_e,ao);
input [31:0] a,b,instr_e;
input [3:0] aluop;
output [31:0] ao;//เปฃก

wire [4:0] shamt;
assign shamt=instr_e[10:6];
wire [31:0] tmp[15:0];

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

endmodule
