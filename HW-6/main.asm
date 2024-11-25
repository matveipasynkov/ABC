.include "macros.inc"

.eqv size 64

.data
choice: .asciz "Do you want to write a string or watch an example? (positive integer - yes, otherwise - no): "
hello: .asciz "hello"
write_a_string: .asciz "Write a string: "
input_string: .space size
output_string: .space size

.text
main:
    la a0 choice
    li a7 4
    ecall
  
    li a7 5
    ecall
    
    bgtz a0 manual
    blez a0 autotest 
    
manual:
    la a0 write_a_string
    li a7 4
    ecall
    
    la a0 input_string
    li a1 size
    li a7 8
    ecall
    
    la a1 output_string
    
    strcpy a0 a1
    
    la a0 output_string
    li a7 4
    ecall
    
    li a7 10
    ecall 
    
autotest:
    la a0 hello
    la a1 output_string
    
    strcpy a0 a1
    
    la a0 output_string
    li a7 4
    ecall
    
    li a7 10
    ecall