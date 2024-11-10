# Macros

# Macro, which we use to get double from user.
# Input: nothing
# Output: fa0 - double number from user.
.macro input
    jal _input
.end_macro

# Macro, which we use to solve the task.
# Input: FPU register, which stores double number from user.
# Output: fa0 - double number of result.
.macro task %reg
    fmv.d fa0 %reg
    jal _task
.end_macro

# Macro, which we use to print result's double number.
# Input: FPU register, which stores double number with result.
# Output: result on display.
.macro print %reg
    fmv.d fa0 %reg
    jal _print
.end_macro 

# Macro, which we use to repeat main.
# Input: nothing.
# Output: a0 - positive integer - yes, otherwise - no.
.macro repeat_task
    jal _repeat_task
.end_macro

# Macro, which we use to ask the user to choose a mode.
# Input: nothing.
# Output: a0 -- positive - manual, negative or 0 - run autotests.
.macro choose_mode
    jal _choose_mode
.end_macro

# Macro, which we use to run test.
# Input: label of test in Data Segment.
# Output: result of test on display.
.macro run_test %label_test
    fld fa0 %label_test t0
    jal _run_test
.end_macro