# swap data between 2 registers

.text
main:
li $t0, 0x00100 # load the first number
li $t1, 0x00299 # load the second number
move $t2, $t1 #move the second number to a temporary register
move $t1, $t0 # move the first number to the second register
move $t0, $t2 # move the saved temp to the first register

li $v0, 10 # exit the program
syscall
