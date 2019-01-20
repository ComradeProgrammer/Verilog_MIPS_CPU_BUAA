.text
#k0 is start k1 is end
ori $a1,$0,32
start:
slt $t7,$k0,$k1
beq $t7,$0,else
nop
	loop:
		lw $a0,0x7f20($0)
		andi $a0,$a0,32
	bne $a0,$a1,loop
	nop
	lw $a3,0($k0)
	addiu $k0,$k0,4
	sw $a3,0x7f10($0)
	sw $k0,0x7f38($0)

else:
j start
nop

.ktext 0x4180
lw $a2,0x7f10($0)
sw $a2,0($k1)
addiu $k1,$k1,4
eret

