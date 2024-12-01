# Pasynkov Matvei Evgenievich, Variant 30
.include "macros.inc"
.include "data.asm"

.text
.globl prog_start, manual

prog_start:  
    load_constants # loading necessary constants.
    li t0 'Y'
    li t1 'N'
    
    la a0 choose_mode # loading address of message with question.
    la a1 answer # buffer for answer
    li a2 10 # maximum characters
    li a7 54 # ecall for graphic window
    ecall
    li a0 0
    
    lb a0 answer # loading first character from answer.
    
    beq a0 t0 manual # if answer is yes => we are going to manual. 
    # otherwise, we are going to autotests.
    
auto_tests:
    la a0 test_path_1 # loading first test
    la a1 data
    run_test_read a0 a1 # program for reading test file
    
    la a0 data
    la a1 output_data
    process_string a0 a1 # program for solving task.
    
    la a0 output_test_path1 
    la a1 output_data
    run_test_write a0 a1 # program for writing test file
    
    la a0 data
    la a1 output_data
    clear_data a0 a1 # program for cleating buffers
    
    la a1 data 
    la a0 test_path_2 # loading second test
    run_test_read a0 a1
    
    la a0 data
    la a1 output_data
    process_string a0 a1
    
    la a0 output_test_path2
    la a1 output_data
    run_test_write a0 a1
    
    la a0 data
    la a1 output_data
    clear_data a0 a1
    
    la a0 test_path_3 # loading third test
    la a1 data
    run_test_read a0 a1
    
    la a0 data
    la a1 output_data
    process_string a0 a1
    
    la a0 output_test_path3
    la a1 output_data
    run_test_write a0 a1
    
    la a0 data
    la a1 output_data
    clear_data a0 a1
    
    la a0 test_path_4 # loading fourth test
    la a1 data
    run_test_read a0 a1
    
    la a0 data
    la a1 output_data
    process_string a0 a1
    
    la a0 output_test_path4
    la a1 output_data
    run_test_write a0 a1
    
    la a0 data
    la a1 output_data
    clear_data a0 a1
    
    li a7 10 # stopping program.
    ecall
    
manual: 
    la a0 data # loading buffer for saving input data
    input a0 # reading file
    
    bgtz a0 end_main # if the filname is incorrect, stop the program.
    
    la a0, data         
    la a1, output_data        
    process_string a0 a1  # program for solving task.
    
    la a0 output_data
    print a0 # saving result
    
    la a0 output_data
    print_in_console a0 # program for printing in console.
    
    bgtz a0 end_main
    
end_main: 
    # Завершение программы
    clear_constants # clearing constants.
    li a7, 10                 # syscall for stopping program.
    ecall
