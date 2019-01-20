loop:
	lw $s0,0x7f2c($0)
	lw $s1,0x7f30($0)	
	lw $s2,0x7f40($0)
	
	ori $s3,$0,1
	bne $s3,$s2,else1
	nop
		addu $s4,$s0,$s1
		j end
		nop
	else1:
	ori $s3,$0,2
	bne $s3,$s2,else2
	nop
		subu $s4,$s0,$s1
		j end
		nop
	else2:
	ori $s3,$0,4
	bne $s3,$s2,else3
	nop
		or $s4,$s0,$s1
		j end
		nop
	else3:
	ori $s3,$0,8
	bne $s3,$s2,else4
	nop
		and $s4,$s0,$s1
		j end
		nop
	else4:
	ori $s3,$0,16
	bne $s3,$s2,else5
	nop
		xor $s4,$s0,$s1
		j end
		nop
	else5:
	ori $s3,$0,32
	bne $s3,$s2,else6
	nop
		nor $s4,$s0,$s1
		j end
		nop
	else6:
	ori $s3,$0,64
	bne $s3,$s2,else7
	nop
		slt $s4,$s0,$s1
		j end
		nop
	else7:
	ori $s3,$0,128
	bne $s3,$s2,end
	nop
		sllv  $s4,$s0,$s1
		j end
		nop
	end:
	sw $s4,0x7f38($0)
	sw $s4,0x7f34($0)
	j loop
	nop
