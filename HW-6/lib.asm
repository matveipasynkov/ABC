.include "macros.inc"

.globl _strcpy
.text
_strcpy:
    addi sp sp -4
    sw ra (sp)
    
    mv t0 a0
    mv t1 a1
loop:
    lb t2 (t0)
    sb t2 (t1)
    
    beqz t2 end_loop
    
    addi t0 t0 1
    addi t1 t1 1
    
    j loop
end_loop:
    lw ra (sp)
    addi sp sp 4
    
    ret