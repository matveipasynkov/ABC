.include "data.asm"
.include "macros.inc"

.text
.globl _input, _print, _process_string, _remove_newline_prog, _print_in_console, _run_test_read, _run_test_write, _clear_data
# Program for taking input data from user's file.
# input: a0 - address of data, which stores input from user.
# output: nothing.
_input: 
    mv t2 a0
    addi sp sp -4
    sw ra (sp)
    
    la a0 write_input_path
    la a1 input_path
    li a2 512
    li a7 54
    ecall
    
    la a0, input_path        
    lb t0, 0(a0)          
    li t1, 10             
    
    la a0 input_path
    li a1 0
    remove_newline_prog a0 a1
    
    li   a7, 1024    
    la   a0, input_path   
    li   a1, 0       
    ecall            
    mv   t6, a0      
    
    beq a0 s10 error_reading
    
    li t0 0
    
read_loop:
    mv a0 t6
    la a1 buffer
    li a2 512
    li a7 63
    ecall
    
    bltz a0 error_reading
    beqz a0 end_loop
    
    add t0 t0 a0
    mv t1 a0
    
    la t3 buffer
    bge t0 s8 end_loop
saving_data_loop:
    beqz t1 read_loop
    lb t4 (t3)
    sb t4 (t2)
    
    addi t3 t3 1
    addi t2 t2 1
    addi t1 t1 -1
    j saving_data_loop
error_reading: # if error occured.
    la a0 error_path
    li a1 0
    li a7 55
    ecall 
    
    lw ra (sp)
    addi sp sp 4
    
    li a0 1
    
    ret
end_loop:
    li   a7, 57       
    mv   a0, t6       
    ecall            
    
    lw ra (sp)
    addi sp sp 4
    
    li a0 0
    
    ret
# Program for printing result data and saving in user's file.
# input: a0 - address of data, which stores result.
# output: nothing.  
_print:
    mv t2 a0
    addi sp sp -4
    sw ra (sp)
    
    la a0 write_output_path
    la a1 output_path
    li a2 512
    li a7 54
    ecall
    
    la a0 output_path
    li a1 1
    remove_newline_prog a0 a1
    
    li   a7, 1024     
    la   a0, output_path     
    li   a1, 1       
    ecall            
    mv   t6, a0      
    
    beq a0 s10 error_writing
    
    li t0 0
    li t1 512
    la t3 buffer
    mv t5 s8
loading_data_loop:
    beqz t1 write_loop
    beqz t5 write_loop
    
    lb t4 (t2)
    sb t4 (t3)
    
    addi t3 t3 1
    addi t2 t2 1
    addi t1 t1 -1
    addi t5 t5 -1
    j loading_data_loop
write_loop:
    mv a0 t6
    la a1 buffer
    li a2 512
    li a7 64
    ecall
   
    bltz a0 error_writing
    beqz a0 end_write_loop
    
    li t1 512
    la t3 buffer
    
    blez t5 end_write_loop
    
    j loading_data_loop
error_writing: # if error occured.
    la a0 error_path
    li a1 0
    li a7 55
    ecall 
    
    lw ra (sp)
    addi sp sp 4
    
    li a0 1
    
    ret   
end_write_loop:    
    li a7 57
    mv a0 t6
    ecall
    
    lw ra (sp)
    addi sp sp 4
    
    li a0 0
    
    ret

# Program for solving task.
# input: a0 - address of data, which stores input from user, a1 - address of data, which will store the result.
# output: nothing.
_process_string:
    addi sp sp -4
    sw ra (sp)
    
    li t3 0
    li t4 0
process_loop:
    addi t3 t3 1
    lb t1, 0(a0)              
    beq t1, zero, finish     
    
    blt t1 s2 else
    ble t1 s3 if_word_started
    j else
if_word_started:
    li t4 1
    j continue_loop
else:
    blt t1 s0 continue_else
    ble t1 s1 continue_loop
continue_else:
    li t4 0
continue_loop:
    # checking the letter
    blt t1, s0, not_letter   # if symbol is less than 'A' - it is not a letter
    bgt t1, s1, not_letter   # if symbol is greater than 'Z' - it is not a letter
    bgtz t4 not_letter # if word started -> skip

    # copy word
    beqz zero, copy_word
    bge t3 s8 finish
    
    j next_char             

not_letter:
    j next_char              

copy_word:
copy_loop:
    addi t3 t3 1
    
    sb t1, 0(a1)             
    addi a1, a1, 1         
    addi a0, a0, 1         
    lb t1, 0(a0)             

    blt t1, s0, word_end     
    ble t1, s1, copy_loop
    bgt t1, s3, word_end
    blt t1, s2, word_end
    bge t3 s8 finish
    j copy_loop

word_end:
    sb s4, 0(a1)           
    addi a1, a1, 1           
    j process_loop            

next_char:
    addi a0, a0, 1          
    j process_loop       

finish:
    addi a1, a1, -1         
    sb s5, 0(a1)           
    
    lw ra (sp)
    addi sp sp 4
    
    ret                   
# Program for removing '\n' from user's name of file
# input: a0 - user's path, a1 - type of file (0 - input, 1 - output)
# output: nothing.
_remove_newline_prog:
    addi sp sp -4
    sw ra (sp)
remove_newline:
    beq t0, t1, end_remove_newline 
    addi a0, a0, 1      
    lb t0, 0(a0)     
    bnez t0, remove_newline  
end_remove_newline:
    beqz a1 remove_newline_from_input
    sb zero -1(a0)
    j return_from_remove_newline
remove_newline_from_input:
    sb zero, (a0)     
return_from_remove_newline:
    lw ra (sp)
    addi sp sp 4
    
    ret
# Program for printing result in console.
# input: a0 - result's data.
# output: nothing.
_print_in_console:
    mv t3 a0
    addi sp sp -4
    sw ra (sp)
    
    li t0 'Y'
    li t1 'N'
    
    la a0 ask_to_display_results  
    la a1 answer
    li a2 10
    li a7 54
    ecall
    
    li a0 0
    
    lb a0 answer
    
    beq a0 t0 agree_to_print
    beq a0 t1 end_display_on_console
    
    la a0 incorrect_answer
    li a7 4
    ecall
    j end_display_on_console
    
agree_to_print:
    mv a0 t3
    li a7 4
    ecall

end_display_on_console:
    lw ra (sp)
    addi sp sp -4
    ret
# Program for reading test file.
# input: a0 - test's path, a1 - address of data, which will store input.
# output: nothing.
_run_test_read:
    mv t2 a1
    
    addi sp sp -4
    sw ra (sp)
    
    li   a7, 1024     
    li   a1, 0        
    ecall             
    mv   t6, a0      
    
    beq a0 s10 run_test_error_reading
    
    li t0 0
    
run_test_read_loop:
    mv a0 t6
    la a1 buffer
    li a2 512
    li a7 63
    ecall
    
    bltz a0 run_test_error_reading
    beqz a0 run_test_end_loop
    
    add t0 t0 a0
    mv t1 a0
    
    la t3 buffer
    bge t0 s8 run_test_end_loop
run_test_saving_data_loop:
    beqz t1 run_test_read_loop
    lb t4 (t3)
    sb t4 (t2)
    
    addi t3 t3 1
    addi t2 t2 1
    addi t1 t1 -1
    j run_test_saving_data_loop
run_test_error_reading:
    la a0 error_path
    li a7 4
    ecall 
    
    lw ra (sp)
    addi sp sp 4
    
    li a0 1
    
    ret
run_test_end_loop:
    li   a7, 57      
    mv   a0, t6      
    ecall           
    
    lw ra (sp)
    addi sp sp 4
    
    li a0 0
    
    ret
# Program for solving task.
# input: a0 - path for saving data, a1 - address of data, which stores the result.
# output: nothing.
_run_test_write:
    mv t2 a1
    
    addi sp sp -4
    sw ra (sp)
    
    li   a7, 1024     
    li   a1, 1        
    ecall             
    mv   t6, a0    
    
    beq a0 s10 run_test_error_writing
    
    li t0 0
    li t1 512
    la t3 buffer
    mv t5 s8
run_test_loading_data_loop:
    beqz t1 run_test_write_loop
    beqz t5 run_test_write_loop
    
    lb t4 (t2)
    sb t4 (t3)
    
    addi t3 t3 1
    addi t2 t2 1
    addi t1 t1 -1
    addi t5 t5 -1
    j run_test_loading_data_loop
run_test_write_loop:
    mv a0 t6
    la a1 buffer
    li a2 512
    li a7 64
    ecall
   
    bltz a0 run_test_error_writing
    beqz a0 run_test_end_write_loop
    
    li t1 512
    la t3 buffer
    
    blez t5 run_test_end_write_loop
    
    j run_test_loading_data_loop
run_test_error_writing:
    la a0 error_path
    li a7 4
    ecall 
    
    lw ra (sp)
    addi sp sp 4
    
    li a0 1
    
    ret   
run_test_end_write_loop:    
    li a7 57
    mv a0 t6
    ecall
    
    lw ra (sp)
    addi sp sp 4
    
    li a0 0
    
    ret
# Program for clearing data.
# input: a0 - address of data, which stores input from user, a1 - address of data, which stores the result.
# output: nothing.
_clear_data:
    addi sp sp -4
    sw ra (sp)
    
    mv t0 s8
    mv t1 a0
    mv t2 a1
clear_loop:
    beqz t0 end_clear_loop
    
    sb zero (t1)
    sb zero (t2)
    
    addi t1 t1 1
    addi t2 t2 1
    addi t0 t0 -1
    
    j clear_loop
end_clear_loop:

    lw ra (sp)
    addi sp sp 4
    
    ret
