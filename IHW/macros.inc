# gets register as a parameter, and returns in a0 the flag of success in case of reading array A. if a0 = 0 => correct input.
.macro check_value %reg # macro, which we use to check number of elements of array, which user gave as input.
    mv a0 %reg # move from given register to a0 as input-register of _check_value
    jal _check_value # jump to _check_value
.end_macro

# gets two labels of start of array and end of array, which also stores a number of elements in array. returnes nothing.
.macro input %arrend_a %array_a # macro, which we use to get an array from user.
    la a1 %arrend_a # load address in a1 of the end of array A, which also stores a number of elements in array in heap.
    la a3 %array_a # load address in a3 of the start of array A.
    jal _input # jump to _input
.end_macro 

# gets four labels of the start of array to sort, the end of array to sort, which also stores the number of elements in input array
# the start of array with result, the end of array with result. returnes nothing.
.macro task %array_a %array_b %arrend_a %arrend_b # macro, which we use to solve the task from my variant by making an array b.
    la a0 %array_a # load address of the start of array A.
    la a1 %array_b # load address of the start of array B.
    la a2 %arrend_a # load address of the end of array A, which stores the number of elements in array A.
    la a3 %arrend_b # load address of the end of array B.
    jal _task # jump to _task
.end_macro

# gets two labels of the start of array to print, the end of array, which stores the number of elements in array.
# returnes nothing.
.macro print %array_b %arrend_b # macro, which we use to print the array.
    la a0 %array_b # load addres of the start of array.
    la a1 %arrend_b # load address of the end of array, which stores the number of elements in array.
    jal _print # jump to _print
.end_macro

# gets five labels of message about starting test, the start of test-array to sort, the end of test-array to sort, which also stores the number of elements in test-array
# the start of array with result, the end of array with result. returnes nothing.
.macro test %test_start_msg %test_data %test_len %array_b %arrend_b # macro, which we use to start test for test-array.
    la a0 %test_start_msg # load address of message of starting test.
    li a7 4 # syscall to print message.
    ecall # print message.
    
    task %test_data %array_b %test_len %arrend_b # start task with macro
    print %array_b %arrend_b # print result
.end_macro

# gets nothing. returnes the answer from user in a0.
.macro choose_mode # macro, which we use to print message of choosing mode and get the answer from user.
.data # data segment
choose_mode_msg: .asciz "Choose mode (0 - manual input; positive integer - auto test): " # store text of message.
.text
    la a0 choose_mode_msg # load address of the text of message
    li a7 4 # syscall to print message
    ecall # print message

    li a7 5 # syscall to get integer from user.
    ecall # get integer in a0
.end_macro  

# gets nothing. returnes the answer from user in a0.
.macro repeat_task # macro, which we use to print message of repeating task and getting the answer from user.
.data # data segment
ask_new_attempt: .asciz "Do you want to repeat (0 - yes, positive integer - no)?: " # text of message
.text
    la a0, ask_new_attempt # load address of the text of message
    li a7, 4  # syscall to print message
    ecall # print message

    li a7, 5 # syscall to get integer from user.      
    ecall # get integer in a0.
.end_macro 
