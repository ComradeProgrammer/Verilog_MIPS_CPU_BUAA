`define special 6'b000000
`define ori 6'b001101
`define lw 6'b100011
`define sw 6'b101011
`define beq 6'b000100
`define lui 6'b001111
`define jal 6'b000011
`define j   6'b000010
`define lb  6'b100000
`define lbu 6'b100100
`define lh  6'b100001
`define lhu 6'b100101
`define sb  6'b101000
`define sh  6'b101001
`define xori 6'b001110
`define addi 6'b001000
`define addiu 6'b001001
`define andi 6'b001100
`define xori 6'b001110
`define slti 6'b001010
`define sltiu 6'b001011
`define bgezbltz 6'b000001
`define bgtz 6'b000111
`define blez 6'b000110
`define bgez_rt 5'b00001
`define bltz_rt 5'b00000
`define bne 6'b000101

`define jr_funct   6'b001000
`define addu_funct 6'b100001
`define subu_funct 6'b100011
`define add_funct  6'b100000
`define sub_funct  6'b100010
`define sll_funct  6'b000000
`define sra_funct  6'b000011
`define srl_funct  6'b000010
`define sllv_funct 6'b000100
`define srav_funct 6'b000111
`define srlv_funct 6'b000110
`define or_funct  6'b100101
`define xor_funct  6'b100110
`define and_funct 6'b100100
`define nor_funct 6'b100111
`define slt_funct 6'b101010
`define sltu_funct 6'b101011
`define jalr_funct 6'b001001

`define mfhi_funct 6'b010000
`define mflo_funct 6'b010010
`define mthi_funct 6'b010001
`define mtlo_funct 6'b010011
`define mult_funct 6'b011000
`define multu_funct 6'b011001
`define div_funct  6'b011010
`define divu_funct 6'b011011
`define add_funct  6'b100000
`define sub_funct  6'b100010

//-------res-------------
`define nw 0
`define alu 1
`define dm 2
`define pc 3
`define other 4
//-fd:fv1dctrl,fv2dctrl-------
`define fd_pc8_e 4
`define fd_oth_e 3
`define fd_ao_m 2
`define fd_pc8_m 1
`define fd_rd 0
//--regdst---------------
`define regdst_rd 0
`define regdst_rt 1
`define regdst_31 2
//-------other------------
`define oth_ext 0
//------falue----------
`define falue_pc8_m 3
`define falue_ao_m 2
`define falue_wd_w 1
`define falue_v 0

//---------memtoreg------------
`define memtoreg_ao 2
`define memtoreg_dr 1
`define memtoreg_pc 0
//--------------------aluop--
`define alu_oth 0
`define alu_add 1
`define alu_sub 2
`define alu_or 3
`define alu_and 4
`define alu_sll 5
`define alu_srl 6
`define alu_sra 7
`define alu_sllv 8
`define alu_srlv 9
`define alu_srav 10
`define alu_xor 11
`define alu_nor 12
`define alu_slt 13
`define alu_sltu 14
//------------------npcop-----
`define npc_16 0
`define npc_26 1
`define npc_reg 2
//--------------------extop---------
`define ext_unsign 0
`define ext_sign 1
`define ext_lui 2
//-------------------alusrc--
`define alusrc_rd2 0
`define alusrc_oth 1
//=====================multdiv=======
`define md_mult 0
`define md_multu 1
`define md_div 2
`define md_divu 3
//--------------------wordmode
`define wm_bu 4
`define wm_bs 3
`define wm_hu 2
`define wm_hs 1
`define wm_wd 0