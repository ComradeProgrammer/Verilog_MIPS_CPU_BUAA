`define special 6'b000000
`define ori 6'b001101
`define lw 6'b100011
`define sw 6'b101011
`define beq 6'b000100
`define lui 6'b001111
`define jal 6'b000011
`define lhu 6'b100101
`define lbu 6'b100100
`define sb 6'b101000
`define sh 6'b101001
`define addiu 6'b001001
`define bgezorbltz 6'b000001
`define bgtz 6'b000111
`define blez 6'b000110
`define j 6'b000010
`define slti 6'b001010






`define slt_funct 6'b101010
`define jr_funct 6'b001000
`define addu_funct 6'b100001
`define subu_funct 6'b100011
`define jalr_funct 6'b001001
`define sll_funct 6'b000000
`define srl_funct 6'b000010
`define sra_funct 6'b000011
`define sllv_funct 6'b000100
`define srav_funct 6'b000111
`define srlv_funct 6'b000110
//---------------------------regdst----
`define regdst_rd 0
`define regdst_rt 1
`define regdst_31 2
//-------------------alusrc--
`define alusrc_rd2 0
`define alusrc_ext 1
//---------------------memtoreg---
`define mtr_alu 0
`define mtr_dm 1
`define mtr_ext 2
`define mtr_pc4 3
`define mtr_slt 4
`define mtr_shift 5
`define mtr_slti 6
//--------------------aluop--`
`define alu_add 1
`define alu_sub 2
`define alu_or 3
//------------------npcop-----
`define npc_16 0
`define npc_26 1
`define npc_reg 2
//--------------------extop---------
`define ext_unsign 0
`define ext_sign 1
`define ext_lui 2