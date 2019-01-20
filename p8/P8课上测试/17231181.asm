.text
ori $a0,1
ori $a1,2
ori $a2,3
ori $a3,0x1fff
loop:
	lw $s0,0x7f2c($0)#s0 add
	and $s1,$s0,$a2
	bne $s1,$0,loop
	nop#duiqi
	sltu $t7,$s0,$a3
	beq $t7,$0,loop
	nop
	
	lw $s2,0x7f30($0)#s2 value
	lw $s3,0x7f40($0)#s3 user
	
	bne $s3,$a0,else1
	nop
	sw $s2,0($s0)
	sw $s2,0x7f38($0)
	j end
	nop
	
	else1:
	bne $s3,$a1,end
	nop
	lw $s4,0($s0)
	sw $s4,0x7f38($0)
	j end
	nop
	
	end:
	j loop
	nop
	
	
	
		
	
	