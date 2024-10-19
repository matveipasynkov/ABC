# Data Segment, which we use in our programs.
.data
message_error: .asciz "Wrong number. Number of elements must be from 1 to 10.\n"
first_test_start_msg: .asciz "First Test.\n--------------------\n"
second_test_start_msg: .asciz "Second Test.\n--------------------\n"
third_test_start_msg: .asciz "Third Test.\n--------------------\n"
fourth_test_start_msg: .asciz "Fourth Test.\n--------------------\n"
message_invalid_mode: .asciz "Invalid mode. Please choose 0 or 1.\n"
ask_to_input: .asciz "Enter number: "
ln: .asciz "\n"
num_of_elem: .asciz "How many elements will be in array (number from 1 to 10)?: "

.align 2
test_data_1: .word 3, 1, 4
test_data_len_1: .word 3
test_data_2: .word 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
test_data_len_2: .word 10
test_data_3: .word 1, 2, 3, 4, 5
test_data_len_3: .word 5
test_data_4: .word 7, 8, 9, 5, 2, 4
test_data_len_4: .word 6

.align 2
array_a: .space 40
arrend_a: .word 0
array_b: .space 40
arrend_b: .word 0
