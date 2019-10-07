.data
prompt:     .asciiz     "Enter string to comapre to: "
eqmsg:      .asciiz     "strings are equal\n"
nemsg:      .asciiz     "strings are not equal\n"
str1:       .space      80
str2: .asciiz "ahmed\n"

.text

main:
    la      $s2,str1
    la      $s3, str2
    move    $t2,$s2

    la $a0, prompt
    li $v0, 4
    syscall

    move    $a0,$t2
    li      $a1,79
    li      $v0,8
    syscall

cmploop:
    lb      $t2,($s2)
    lb      $t3,($s3)
    bne     $t2,$t3,cmpne               # if not equal

    beq     $t2,$zero,cmpeq             # if all chars are equal
    addi    $s2,$s2,1                   # point to next char
    addi    $s3,$s3,1                   # point to next char
    j       cmploop

# if not equal
cmpne:
    la      $a0,nemsg
    li      $v0,4
    syscall
    j       exit

# if equal
cmpeq:
    la      $a0,eqmsg
    li      $v0,4
    syscall
    j       exit

# exit program
exit:
    li      $v0,10
    syscall
