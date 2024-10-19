.include "macros.inc"
.include "data.asm" # Data Segment

.globl _input _task _print _check_value

.text
_input: # input: a1 - end of array, a3 - start of array; output: a0 - flag of success.
    addi sp sp -4 # using stack to store the return address
    sw ra (sp)

    la a0 num_of_elem  # loading address of text and print it with syscall 4
    li a7 4              
    ecall

    li a7 5 # getting number from user
    ecall
    mv t2 a0 # save it in t2

    check_value a0 # check the number of elements from user

    sw t2 (a1) # save the number from user in the end of array

    mv t0 a3 # save the start of array
    li t1 0       

    beqz a0 loop # if we got a correct number from user, start the loop to get the numbers of array.

    lw ra (sp)  # otherwise, get the return address and clear the value from stack  
    addi sp sp 4         
    li a0 1  # load 1 as a result in register a0, which means that we have an error, while we were getting the array from user.
    ret

loop:
    la a0 ask_to_input  # load address of message, where we ask user to give us an element of the array.
    li a7 4               
    ecall # print message

    li a7 5 # getting element
    ecall

    sw a0 (t0) # saving element and change the position of pointer to save an element and number of elements, which user gave us
    addi t0 t0 4         
    addi t1 t1 1       

    blt t1 t2 loop # check, that we got all elements of array.

end_loop:
    li t1 0
    li t2 0
    
    lw ra (sp)          
    addi sp sp 4 # getting return address from stack.

    li a0 0 # return in a0 the flag of getting success of reading the array from user.
    ret

_check_value: # input: a0 - value to check; output: a0 - flag of success.
    addi sp sp -4  # saving return address in stack.
    sw ra (sp)
    
    li t0 1             
    addi sp sp -4  # saving the minimum correct number of elements in stack as a local variable.
    sw t0 (sp)
    
    li t0 10 # saving the maximum correct number of elements in t0.

    bgt a0 t0 if_greater_10  # if number of elements is greater than 10: jump to if_greater_10

    lw t0 (sp)        # clear the minimum number of elements from stack and put it in register t0. 
    addi sp sp 4  

    blt a0 t0 if_less_1    # if number of elements is less than 1: jump to if_less_1

    li t0 0               

    li a0 0   # if the number of elements is correct => return the success of checking value as 0 in register a0.
    lw ra (sp)   # get return address from stack and clear the value from stack.
    addi sp sp 4       
    ret

if_greater_10: # if the number of elements is greater than 10.
    li a0 1    # if the number of elements is incorrect => return the failure of checking value as 1 in register a0.

    lw t0 (sp)          
    addi sp sp 4  # clear the number of minimum correct elements of array from stack.

    li t0 0            

    lw ra (sp)    # get the return address from stack and clear this value from stack.
    addi sp sp 4  
    ret

if_less_1: # if the number of elements is less than 1.
    li a0 1 # if the number of elements is incorrect => return the failure of checking value as 1 in register a0.

    li t0 0          

    lw ra (sp)  # get the return address from stack and clear this value from stack.
    addi sp sp 4       
    ret

# input: a0 - pointer to start of array; a1 - pointer to the end of array, which stores the number of elements.
# output: nothing.
_print:
    addi sp sp -4   # save return address in stack.
    sw ra (sp)

    mv t0 a0  # mv to t0 the address of the start of the array.
    lw t1 (a1) # load the numbers of element of array, which stores at the end of array.
    li t2 0         

print_loop:
    lw a0 0(t0)         
    
    li a7 1   # syscall to print integer from pointer of the current element of array.
    ecall                

    la a0 ln            
    li a7 4              
    ecall               

    addi t0 t0 4  # displace the pointer
    addi t2 t2 1  # add +1 to the counter of the number of printed elements.

    blt t2 t1 print_loop  # continue the cycle if the number of printed elements is less than number of all elements.

    lw ra (sp) # get return address and clear this value from stack.
    addi sp sp 4  
    ret                  
# input: a0 - address of the start of array A, a1 - address of the start of array B
# a2 - address of the end of array A, which stores the number of elements in array A.
# a3 - address of the end of array B.
# output: nothing.
_task:
    addi sp sp -4 # save return address in stack.
    sw ra (sp)

    lw t0 (a2) # save to the end of array B the number of elements of array A.
    sw t0 (a3)      
    mv t0 a0  # move to t0 the pointer to the current number of array A.
    mv t1 a1  # move to t0 the pointer to the current number of array B.
    li t2 10        

copy_loop: # loop, which copy elements from array A to array B.
    lw t3 0(t0)    # move the element     
    sw t3 0(t1)        

    addi t0 t0 4   # displace pointers
    addi t1 t1 4           
    addi t2 t2 -1          

    bnez t2 copy_loop  # check that there aren't any elements of A, which we should copy to B.

    mv t0 a1           
    lw t1 (a3)     

loop_task_extern: # Then there is the implementation of Bubble Sort of array B.
    addi t1 t1 -1   # number of iterations - 1 of extern loop.
    li t2 0            
    mv t0 a1         

loop_task_inner:
    lw t3 0(t0)   # Inner cycle goes through all elements, compares them, and change them if it is necessary.
    lw t4 4(t0)        

    bgt t3 t4 skip_swap    # Check condition to swap.

    sw t4 0(t0)        
    sw t3 4(t0)      

skip_swap:
    addi t0 t0 4       
    addi t2 t2 1    

    lw t5 (a3)      
    addi t5 t5 -1      
    blt t2 t5 loop_task_inner  # check conditions of innner loop and extern loop.

    bnez t1 loop_task_extern  

    lw ra (sp)     # load return address from stack and clear it from stack.
    addi sp sp 4         
    ret
