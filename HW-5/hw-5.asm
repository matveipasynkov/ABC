.text
main:   
    jal factorial
    li a7 1 # getting result from a0
    ecall
    li a7 10 # stopping program
    ecall
    
factorial:
    addi sp sp -4 # save ra in stack
    sw ra (sp)
    
    li t0 1 # current n!
    li t1 1 # current n
    
loop:
    mulh t2 t0 t1 # head of multiplication
    mul t3 t0 t1 # bottom of multiplication
    
    bnez t2 end # if head of multiplication != 0 => stop the loop
    
    mv t0 t3 # if head of multiplication == 0 => factorial is correct => save result
    addi t1 t1 1 # add 1 to n: n -> n + 1
    
    j loop # repeat loop
    
end:
    mv a0 t1 # save result in a0
    addi a0 a0 -1 # change to last n, where n! is correct
    
    lw ra (sp) # load return address and clear it from stack
    addi sp sp 4
    
    ret