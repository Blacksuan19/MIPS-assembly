.text
	main:
	li $t0, 0x00100
	li $t1, 0x00299
	move $t2, $t1
	move $t1, $t0
	move $t0, $t2
	
	 li $v0, 10
	 syscall 
