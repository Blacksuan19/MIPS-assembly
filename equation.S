.text
	
	main:
	# load the values for x and y to t0 and t1
	li $t0, 3 # x
	li $t1, 5 # y
	# square the x
	mul $t2, $t0, $t0 # x^2
	mul $t4, $t2, 2 # 2x^2
	mul $t5, $t1, $t1 # y^2
	mul $t5, $t5, $t1 # y^3
	add $t6, $t4, $t5 # 2x^2 + 2y^3
	sub $t7, $t6, 10 # 2x^2 + 2y^3 - 10
	move $a0, $t7 # move the result to constant register
	li $v0, 1 # 1 for integer output, 4 for string, and 10 for termination
	syscall
	li $v0, 10
	syscall
	# 2x^2 + 2y^3 - 10