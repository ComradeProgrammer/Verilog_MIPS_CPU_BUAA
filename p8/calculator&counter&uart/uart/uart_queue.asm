.ktext
#k0 is start k1 is end
ori $a1,$0,32
ori $t7,$0,128
start:
beq $k0,$k1,else
nop
	loop:
		lw $a0,0x7f20($0)
		andi $a0,$a0,32
	bne $a0,$a1,loop
	nop
	lw $a3,0($k0)
	addiu $k0,$k0,4
	bne $k0,$t7,tar1
	nop
		ori $k0,$0,0
	tar1:
	sw $a3,0x7f10($0)
	sw $k0,0x7f38($0)

else:
j start
nop

#.ktext 0x4180
.text
lw $a2,0x7f10($0)
sw $a2,0($k1)
addiu $k1,$k1,4
bne $k1,$t7,tar2
nop
	ori $k1,$0,0
tar2:

eret

