# Pasynkov Matvei, BPI237, Variant 22.
.include "macros.inc" # macros inc. stores all macros.
.include "data.asm" # data.asm stores all data segment, which we use in out program.

.text
.globl prog_main
# The beginning of the program, where we in choose_mod (macro from macros.inc) ask,
# whether he wants to start manual input or use automatic testing.
prog_main:
    choose_mode  
    beqz a0, manual_mode # choose_mod returns the result in a0. If a0 = 0, run manual_mode, else if a0 > 0, run tests.
    bgtz a0, auto_test_mode

error_invalid_mode: # in case, where user entered negative integer, our program will return a message with error.
    la a0 message_invalid_mode # load message
    li a7 4 # 4 - syscall to print message
    ecall # print message
    jal prog_main # jump to start of program     

# Manual mode
manual_mode:
    input arrend_a array_a # macro, which is stored in macros.inc, which we use to get an array
    bgtz a0 error_stop_wrong_N # macro returns in a0, the flag of success in case of reading array A. if a0 = 0 => error occcured. Otherwise, we continue to work with array A.
    task array_a array_b arrend_a arrend_b # macro, which is stored in macros.inc, which we use to solve the task from my variant by making an array b. 
    print array_b arrend_b # macro, which is stored in macros.inc, which we use to print array B.   
    
    repeat_task # macro, which is stored in macros.inc, which we use to ask a user to continue the work of our program.
    beqz a0, prog_main # result will be in a0 register. If a0 = 0, we repeat the work of our program, otherwise, we stop it.
    
    li a7 10 # syscall to stop the program
    ecall # stop the program

auto_test_mode:
    test first_test_start_msg test_data_1 test_data_len_1 array_b arrend_b # macro, which is stored in macros.inc, to start the test
    test second_test_start_msg test_data_2 test_data_len_2 array_b arrend_b # macro, which is stored in macros.inc, to start the test
    test third_test_start_msg test_data_3 test_data_len_3 array_b arrend_b # macro, which is stored in macros.inc, to start the test
    test fourth_test_start_msg test_data_4 test_data_len_4 array_b arrend_b # macro, which is stored in macros.inc, to start the test

    repeat_task # macro, which is stored in macros.inc, which we use to ask a user to continue the work of our program.
    beqz a0, prog_main #result will be in a0 register. If a0 = 0, we repeat the work of our program, otherwise, we stop it.
    
    li a7 10 # syscall to stop the program           
    ecall # stop the program

error_stop_wrong_N:
    la a0 message_error # load error message
    li a7 4 # syscall to print message
    ecall # print message

    li a7 10 # syscall to stop the program
    ecall # stop the program
