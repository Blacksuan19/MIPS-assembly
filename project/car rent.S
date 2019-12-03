# Copyright © 2019 blacksuan19
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# license numbers are there to make each car unique (otherwise this looks like
# bad software design)


### actual code (spaghet)
.text

    # only prints out the prompt
    main:

        # print the banner
        jal newline
        jal decor
        li $v0, 4
        la $a0, welcome
        syscall
        jal decor

        # print the menu options
        la $a1, process1
        jal print_formatted
        la $a1, process2
        jal print_formatted
        la $a1, process3
        jal print_formatted
        la $a1, process4
        jal print_formatted
        la $a1, process5
        jal print_formatted

        li $v0, 4
        la $a0, select_process
        syscall

        # read option
        li $v0, 5
        syscall
        move $s1, $v0 # save the option in s1 (we gonna need this later)

    # process the entered option
    process_option:
        beq $s1, 1, check_user # login before showing options
        beq $s1, 2, option2
        beq $s1, 3, option3
        beq $s1, 4, option4
        beq $s1, 5, exit

        li $t0, 5
        slt $t1, $t0, $s1  # check if the number is larger than 5
        beq $t1, 1, invalid # invalid if its larger than 5


### Options Section
    # actual actions for option 1
    option1:
        li $v0, 4
        la $a0, car_models
        syscall

        li $v0, 4
        la $a0, get_car
        syscall

        li $v0, 5
        syscall
        move $t5, $v0

        # disaply the seleced car model
        beq $t5, 1, show_toy
        beq $t5, 2, show_honda
        beq $t5, 3, show_hyu
        beq $t5, 4, show_ford
        beq $t5, 5, show_jeep
        j main

    # actions fo option 2
    option2:
        jal newline
        li $v0, 4
        la $a0, process2
        syscall

        jal newline
        la $a1, reserved_cars
        jal print_string
        j main

    # actions fo option 3
    option3:
        jal newline
        li $v0, 4
        la $a0, process3
        syscall
        jal newline
        la $a1, collected_cars
        jal print_string
        j main

    # actions fo option 4
    option4:
        jal newline
        li $v0, 4
        la $a0, process4
        syscall
        jal newline
        la $a1, collected_cars
        jal print_string
        j main

    # for when the input is larger than 5
    invalid:
        jal newline
        li $v0, 4
        la $a0, wrong
        syscall
        jal newline
        j main


### authentication Section
    # prompt and read username
    check_user:
        # load string and space to compare
        la $s2, input_user
        la $s3, user
        li $t8, 0 # comapre loop control
        move $t1, $s2 # move space to a writable register

        # prompt
        la $a0, user_prompt
        li $v0, 4
        syscall

        # read username
        move $a0, $t1 # move moved space to read register
        li $a1, 10
        li $v0, 8
        syscall
        jal strcmp # compare

    # prompt and read password
    check_pass:
        la $s2, input_pass
        la $s3, pass
        li $t8, 1 # comapre loop control
        move $t1, $s2

        # prompt
        la $a0, pass_prompt
        li $v0, 4
        syscall

        # read password
        move $a0, $t1
        li $a1, 10
        li $v0, 8
        syscall
        jal strcmp # compare

    # compare strings ($s2, $s3)
    strcmp:
        lb $t2,($s2)
        lb $t3,($s3)
        bne $t2, $t3,cmpne # if not equal
        beq $t2, $zero, cmpeq # if equal
        addi $s2, $s2,1 # point to next char
        addi $s3, $s3,1 # point to next char
        j strcmp # tomato

    # if equal
    cmpeq:
        # if the caller is the username function check password next
        beq $t8, $zero, check_pass
        # if pass is correct that means both are correct so start option1
        beq $t8, 1, option1

    # if not equal
    cmpne:
        la $a0, nomatch # print the no match string
        li $v0, 4
        syscall
        beq $t8, $zero, check_user # if caller is username function
        beq $t8, 1, check_pass # if the caller is pass label ask for pass again


### car operations section (option1 stuff mostly)
    ## print out cars based on model
    show_toy:
        la $a1, car1
        jal print_string
        la $a1, car2
        jal print_string
        la $a1, car3
        jal print_string
        la $a1, car4
        jal print_string
        j prompt_car # select a car

    show_honda:
        la $a1, car5
        jal print_string
        la $a1, car6
        jal print_string
        la $a1, car7
        jal print_string
        la $a1, car8
        jal print_string
        j prompt_car # select a car

    show_hyu:
        la $a1, car9
        jal print_string
        la $a1, car10
        jal print_string
        la $a1, car11
        jal print_string
        la $a1, car12
        jal print_string
        j prompt_car # select a car

    show_ford:
        la $a1, car13
        jal print_string
        la $a1, car14
        jal print_string
        la $a1, car15
        jal print_string
        la $a1, car16
        jal print_string
        j prompt_car # select a car

    show_jeep:
        la $a1, car17
        jal print_string
        la $a1, car18
        jal print_string
        la $a1, car18
        jal print_string
        la $a1, car20
        jal print_string
        j prompt_car # select a car

    # ask to select one of the listed cars
    prompt_car:
        li $v0, 4
        la $a0, get_cnumber
        syscall

        li $v0, 5
        syscall
        move $t5, $v0
        j check_car

    # check the entered car number and display status accordingly
    check_car:
        beq $t5, 1, car_reserved
        beq $t5, 2, car_reserved
        beq $t5, 11, car_reserved
        beq $t5, 19, car_reserved
        beq $t5, 16, car_reserved
        beq $t5, 3, car_collected
        beq $t5, 8, car_collected
        beq $t5, 12, car_collected
        beq $t5, 17, car_collected
        beq $t5, 10, car_collected
        beq $t5, 4, car_returned
        beq $t5, 6, car_returned
        beq $t5, 14, car_returned
        beq $t5, 5, car_available
        beq $t5, 7, car_available
        beq $t5, 9, car_available
        beq $t5, 13, car_available
        beq $t5, 15, car_available
        beq $t5, 18, car_available
        beq $t5, 20, car_available
        li $t0, 20
        slt $t1, $t0, $s1  # check if the number is larger than 20
        beq $t1, 1, car_invalid # invalid if its larger than 20

        jr $ra # return to caller

    # if the car is reserved
    car_reserved:
        la $a1, reserved_string
        jal print_string
        la $a1, select_another_car
        jal print_string
        j prompt_car

    # if the car has been collected
    car_collected:
        la $a1, collcted_string
        jal print_string
        la $a1, select_another_car
        jal print_string
        j prompt_car

    # if the car has been returned
    car_returned:
        la $a1, returned_string
        jal print_string
        la $a1, select_another_car
        jal print_string
        j prompt_car

    # if its available ask to reseve
    car_available:
        la $a1, available_string
        jal print_string
        li $t3, 'y' # Y letter ascii value
        li $v0, 12
        syscall
        move $t6, $v0
        bne $t6,$t3, option1 # display cars again if nothing reserved
        beq $t6, $t3, done_reserve # you know whats up
        j exit

    # if the entered number is more than 20
    car_invalid:
        la $a1, invalid_car
        jal print_string
        j prompt_car

    # after the reservation is over we out
    done_reserve:
        la $a1, done_reserve_string # am out of variable names
        jal print_string
        j exit



### Miscellaneous section
    # some decoration
    decor:
        li $v0, 4
        la $a0, decoration
        syscall
        jr $ra # return to caller

    # its high up here, i see no soul but i
    newline:
        addi $a0, $0, 0xA
        addi $v0, $0, 0xB
        syscall
        jr $ra # return to caller

    # print the string in a1, prepended with -
    print_formatted:
        li $v0, 4
        la $a0, dash
        syscall

        li $v0, 4
        move $a0, $a1
        syscall

        jr $ra # return to caller

    # print string at a1
    print_string:
        li $v0, 4
        move $a0, $a1
        syscall

        jr $ra # return to caller

    # am out
    exit:
        li $v0, 10
        syscall



### Data Section
.data
    # each string is terminated with a new line so we wont have to call newline

    # general stuff
    welcome: .asciiz "   Welcome To AJSM Renting\n"
    decoration: .asciiz "===============================\n"
    dash: .asciiz "- "

    # the menu options
    process1: .asciiz "Rent a Car \n"
    process2: .asciiz "List Of Reserved Cars\n"
    process3: .asciiz "List Of Collected cars\n"
    process4: .asciiz "List Of Returned Cars\n"
    process5: .asciiz "Exit"
    wrong: .asciiz "\nInvalid Option!\n"
    select_process: .asciiz "\nSelect Process(1 - 5): "

    # Authentication
    user: .asciiz "abu\n"
    pass: .asciiz "12345\n"
    input_user: .space 10
    input_pass: .space 10
    nomatch: .asciiz "Username or password not in database!\n"
    success: .asciiz "Login Successful.\n"
    user_prompt: .asciiz "Enter Username: "
    pass_prompt: .asciiz "Enter Password: "

    # option 1 stuff
    get_car: .asciiz "Enter the car model number(1-4): "
    get_cnumber: .asciiz "Enter car number: "
    car_models: .asciiz "1.Toyota\n2.Honda\n3.Hyundai\n4.Ford\n5.Jeep\n"
    reserved_string: .asciiz "The selected car is reserved!\n"
    collcted_string: .asciiz "The selected car has been collected\n"
    returned_string: .asciiz "the selected car has been returned\n"
    available_string: .asciiz "Car is available!\nAdd car to reserved cars? (y,n) "
    invalid_car: .asciiz "Invalid number\nPLease enter a number from the list!\n"
    done_reserve_string: .asciiz "Car has been reserved!\n"
    select_another_car: .asciiz "Please select another car\n"


    ## the cars

    car1: .asciiz "1.Toyota CFE 1203\n" # reserved
    car2: .asciiz "2.Toyota GFQ 3455\n" # reserved
    car11: .asciiz "11.Hyundai YVY 8532\n" # reserved
    car19: .asciiz "19.Jeep YUR 4529\n" # reserved
    car16: .asciiz "16.Ford MVJ 3025\n" # reserved
    car3: .asciiz "3.Toyota POA 7163\n" # collected
    car8: .asciiz "8.Honda OPK 7856\n" # collected
    car12: .asciiz "12.Hyundai YUR 4502\n" # collected
    car17: .asciiz "17.Jeep GCY 9582\n" # collected
    car10: .asciiz "10.Hyundai PKO 5069\n" # collected
    car4: .asciiz "4.Toyota VBE 1340\n" # returned
    car6: .asciiz "6.Honda GIU 8532\n" # returned
    car14: .asciiz "14.Ford TTR 0785\n" # return
    car5: .asciiz "5.Honda DNO 0959\n" # available
    car7: .asciiz "7.Honda OHY 9823\n" # available
    car9: .asciiz "9.Hyundai JON 7981\n" # available
    car13: .asciiz "13.Ford RDY 2036\n" # available
    car15: .asciiz "15.Ford HJV 7825\n" # available
    car18: .asciiz "18.Jeep TRT 7235\n" # available
    car20: .asciiz "20.Jeep ERS 3041\n" # available

    reserved_cars: .asciiz "- Toyota CFE 1203\n- Toyota GFQ 3455\n- Hyundai YVY 8532\n- Jeep YUR 4529\n- Ford MVJ 3025\n"
    collected_cars: .asciiz "- Toyota POA 7163\n- Honda OPK 7856\n- Hyundai YUR 4502\n- Jeep GCY 9582\n- Hyundai PKO 5069\n"
    returned_cars: .asciiz "- Toyota VBE 1340\n- Honda GIU 8532\n- Ford TTR 0785\n"
