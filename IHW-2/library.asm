.include "macros.inc"
.include "data.asm"

.globl _input _task _print _choose_mode _repeat_task _run_test # making these labels global for macros.inc.

.text
# Programs.
# input: nothing.
# output: fa0 - double number from user (after using syscall 7).   
_input:
    addi sp sp -4 # saving return address on the stack.
    sw ra (sp)
    
    la a0 ask_x # asking user for input
    li a7 4 # syscall to print string
    ecall # syscall
    
    li a7 7 # syscall to get double in a0
    ecall # syscall
    
    lw ra (sp) # getting return address from stack and returning from program.
    addi sp sp 4
    
    ret
    
# input: fa0 - double number from user.
# output: fa0 - double number of result (after moving result from ft3 in FPU)
_task:
    addi sp sp -4 # saving return address on the stack.
    sw ra (sp)
    
    fmv.d ft0 fa0 # moving number from fa0 to ft0
    
    fld ft1 n t0 # loading n = 5 (because we are calculating root of 5th degree)
    fld ft2 eps t0 # loading necessary accuracy (epsilon)
    
    fdiv.d ft3 ft0 ft1 # saving current result in ft3 (we need it for our algorithm).
    fmv.d ft4 ft0 # saving previous result in ft4 (we need it for our algorithm).
loop:
    fsub.d ft5 ft3 ft4 # checking condition that we have got necessary accuracy (|ft3 - ft4| < eps)
    fabs.d ft5 ft5
    flt.d t0 ft5 ft2
    bnez t0 end_loop
    
    fmv.d ft4 ft3 # implementation of the fast converging iterative algorithm. saving ft3 (x_k) in ft4 as previous result.
    fmul.d ft3 ft4 ft4 # saving in ft3: (x_k) ^ 2
    fmul.d ft3 ft3 ft3 # saving in ft3: (x_k) ^ 4
    fdiv.d ft3 ft0 ft3 # saving in ft3: x / (x_k) ^ 4, where x is a double number from user.
    fadd.d ft3 ft3 ft4 # saving in ft3: x_k + x / (x_k) ^ 4
    fadd.d ft3 ft3 ft4 # saving in ft3: 2 * x_k + x / (x_k) ^ 4
    fadd.d ft3 ft3 ft4 # saving in ft3: 3 * x_k + x / (x_k) ^ 4
    fadd.d ft3 ft3 ft4 # saving in ft3: 4 * x_k + x / (x_k) ^ 4
    fdiv.d ft3 ft3 ft1 # saving in ft3: (4 * x_k + x / (x_k) ^ 4) / 5 = x_(k + 1) according to the algorithm.
    
    fmv.d fa0 ft3 # saving current result (x_(k + 1)) in fa0
    j loop # jumping to the start of loop.
end_loop:
    lw ra (sp) # loading return address from stack.
    addi sp sp 4
    
    ret # returning.
    
# input: fa0 - double number of result.
# output: nothing.
_print:
    addi sp sp -4 # saving return address on the stack.
    sw ra (sp)
    
    la a0 result # loading address of string "Result: " in a0
    li a7 4 # syscall to print a string
    ecall # syscall
    
    li a7 3 # syscall to print a double number of result.
    ecall # syscall
    
    la a0 ln # loading address of string "\n" in a0
    li a7 4 # syscall to print string.
    ecall # syscall.
    
    lw ra (sp) # loading return address.
    addi sp sp 4
    
    ret # returning.

# input: nothing
# output: a0 - positive integer - yes, otherwise - no (after syscall 5)
_repeat_task:
    addi sp sp -4 # saving return address.
    sw ra (sp)
    
    la a0 ask_repeat # asking user to repeat.
    li a7 4 # syscall to print a string.
    ecall # syscall
    
    li a7 5 # syscall to read an integer.
    ecall # syscall.
    
    lw ra (sp) # loading return address
    addi sp sp 4
    
    ret # returning
    
# input: nothing
# output: a0 -- positive - manual, negative or 0 - run autotests (after syscall 4)
_choose_mode:
    addi sp sp -4 # saving return address.
    sw ra (sp)
    
    la a0 ask_mode # asking user about mode.
    li a7 4 # syscall to print string
    ecall # syscall
    
    li a7 5 # syscall to read integer from user.
    ecall # syscall
    
    lw ra (sp) # loading return address.
    addi sp sp 4
    
    ret # returning.
    
# input: fa0: test_number.
# output: nothing.
_run_test:
    addi sp sp -4 # saving return address.
    sw ra (sp)
    
    la a0 test_message # saving test message's address.
    li a7 4 # syscall to write string.
    ecall # syscall
    
    li a7 3 # syscall to write double number.
    ecall # syscall
    
    la a0 ln # saving '\n's address.
    li a7 4 # syscall to write string.
    ecall # syscall.
    
    task fa0 # calling task function.
    print fa0 # calling print function.
    
    lw ra (sp) # loading return address.
    addi sp sp 4
    
    ret # returning.