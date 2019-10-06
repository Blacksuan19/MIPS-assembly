.text

main:
li $t1, 0 # the loop controller
la $a0, Prompt
li $v0, 4 # print the prompt
syscall

la $a0, word
li $a1, 5 # limit the size to 5
li $v0, 8 # read string
syscall

la $t0, word #load word to $t0 so we can modify it
loop:
    lb $t2, 0($t0)
    beq $t1, 4, exit #the total characters is gonna be 4 so exit if thats the case
    la $a0, ($t2) # load the currernt character for output
    li $v0, 11 # syscall 11 to output one character
    syscall
    la $a0, ' '  # add the space
    li $v0, 11
    syscall
    addi $t0, $t0, 1
    add $t1, $t1, 1 # increment the loop controller
    j loop

exit:
li $v0, 10
syscall

.data
Prompt: .asciiz "Enter 4 characters: "
word: .space 5
