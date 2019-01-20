.text 
	ori $s0,$0,11
	li $s1,20000000
	sw $s0,0x7f00($0)#CTRL
	sw $s1,0x7f04($0)#PRESET
loop:
	lw $s2,0x7f2c($0)#switch
	beq $s2,$s3,end#s3 switch old value
	nop
		move $s3,$s2
		move $s4,$s3#$s4 counting
	end:
	sw $s4,0x7f38($0)
	j loop
	nop
.ktext 0x4180
	blez $s4,else
	nop
		addiu $s4,$s4,-1
		j endif
		nop
	else:
		ori $s4,$0,0
	endif:
	eret
	nop

	
	