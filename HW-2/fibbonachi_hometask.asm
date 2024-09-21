main:
    mv t0, zero # псевдокоманда, используящая add, R-type
    li t1, 1 # псевдокоманда, используящая addi, I-type
    li a7, 5 # псевдокоманда, используящая addi, I-type
    ecall # I-type
    mv t3, a0 # псевдокоманда, используящая add, R-type
fib:
    beqz t3, finish # псевдокоманда, используящая beq, SB-type
    add t2, t1, t0 # R-type
    mv t0, t1 # псевдокоманда, используящая add, R-type
    mv t1, t2 # псевдокоманда, используящая add, R-type
    addi t3, t3, -1 # I-type
    j fib # псевдокоманда, используящая jal, UJ-type
finish:
    li a7, 1 # псевдокоманда, используящая addi, I-type
    mv a0, t0 # псевдокоманда, используящая add, R-type
    ecall # I-type
    