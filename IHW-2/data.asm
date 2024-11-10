#Data Segment, for IHW-2.asm, library.asm.
.data
ask_x: .asciz "Enter x: "
result: .asciz "Result: "
ask_repeat: .asciz "Do you want to repeat? (positive - yes, negative or 0 - no): "
ask_mode: .asciz "Choose mode (positive - manual, negative or 0 - run autotests): "
ln: .asciz "\n"
n: .double 5.0
eps: .double 0.000001

test_1: .double -32
test_2: .double -2
test_3: .double -1
test_4: .double 0
test_5: .double 1
test_6: .double 2
test_7: .double 32
test_message: .asciz "----------------\nTest: "