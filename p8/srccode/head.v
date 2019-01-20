`define eret   32'h42000018

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
`define cop0    6'b010000

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

`define mfc0_rs    5'b00000
`define mtc0_rs    5'b00100
//-------res-------------
`define nw 3'd0
`define alu 3'd1
`define dm 3'd2
`define pc 3'd3
`define other 3'd4
//-fd:fv1dctrl,fv2dctrl-------
`define fd_pc8_e 3'd4
`define fd_oth_e 3'd3
`define fd_ao_m 3'd2
`define fd_pc8_m 3'd1
`define fd_rd 3'd0
//--regdst---------------
`define regdst_rd 2'd0
`define regdst_rt 2'd1
`define regdst_31 2'd2
//-------other------------
`define oth_ext 2'd0
//------falue----------
`define falue_pc8_m 3'd3
`define falue_ao_m 3'd2
`define falue_wd_w 3'd1
`define falue_v 3'd0

//---------memtoreg------------
`define memtoreg_ao 2'd2
`define memtoreg_dr 2'd1
`define memtoreg_pc 2'd0
//--------------------aluop--
`define alu_oth 5'd0
`define alu_add 5'd1
`define alu_sub 5'd2
`define alu_or  5'd3
`define alu_and 5'd4
`define alu_sll 5'd5
`define alu_srl 5'd6
`define alu_sra 5'd7
`define alu_sllv 5'd8
`define alu_srlv 5'd9
`define alu_srav 5'd10
`define alu_xor 5'd11
`define alu_nor 5'd12
`define alu_slt 5'd13
`define alu_sltu 5'd14
`define alu_debug 5'd15
//------------------npcop-----
`define npc_16 3'd0
`define npc_26 3'd1
`define npc_reg 3'd2
`define npc_handler 3'd3
`define npc_epc 3'd4
//--------------------extop---------
`define ext_unsign 2'd0
`define ext_sign 2'd1
`define ext_lui 2'd2
//-------------------alusrc--
`define alusrc_rd2 2'd0
`define alusrc_oth 2'd1
//-------------------fepc--
`define fepc_e 3'd2
`define fepc_m 3'd1
`define fepc_cp0 3'd0
//---------exception-----------------------
`define exc_int 5'd0
`define exc_adel 5'd4
`define exc_ades 5'd5
`define exc_ri 5'd10
`define exc_ov 5'd12
//--------------------wordmode-----------
`define wm_bu 3'd4
`define wm_bs 3'd3
`define wm_hu 3'd2
`define wm_hs 3'd1
`define wm_wd 3'd0
