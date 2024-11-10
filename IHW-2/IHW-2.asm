# Pasynkov Matvei Evgenievich, BPI237, Variant 26.
.include "data.asm"
.include "macros.inc"
.text
main:
    choose_mode # macro, where we ask user to choose a mode of main (manual or autotests).
    bgtz a0 manual # branch, if user chose a manual mode (positive integer in a0).
    blez a0 test_program # branch, if user chose an autotest mode (0 or negative integer in a0).

# continue of manual main
manual:
    input # macro, which processes with user's input number
    task fa0 # macro, which solves the task (calculates the root of the 5th degree).
    print fa0 # macro, which prints the result.
    
    repeat_task # macro, which asks user to repeat the task.
    
    bgtz a0 main # if positive integer is in a0 => user wants to repeat the task.
    
    li a7 10 # otherwise, we stop the program.
    ecall
    
# continue of autotesting main
test_program:
    run_test test_1 # macro, which we use to run test.
    run_test test_2
    run_test test_3
    run_test test_4
    run_test test_5
    run_test test_6
    run_test test_7
    
    repeat_task # macro, which asks user to repeat the task.
    
    bgtz a0 main # if positive integer is in a0 => user wants to repeat the task.
    
    li a7 10 # otherwise, we stop the program.
    ecall