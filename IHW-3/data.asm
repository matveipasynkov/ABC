# Data Segment for program
.data
buffer:  .space 512
data: .space 10240
output_data: .space 10240     
space:      .byte 32         
null:       .byte 0         
error_path: .asciz "Error. Incorrect path."
write_input_path: "Write input path: "
write_output_path: "Write output path: "
ask_to_display_results: "Do you want to see result in console? [Y/N]: "
choose_mode: "Do you want to use program manually? [Y/N]: "
incorrect_answer: "Incorrect answer."
answer: .space 10
input_path: .space 512
output_path: .space 512
test_path_1: .asciz "files/test1.txt"
output_test_path1: .asciz "files/result1.txt"
test_path_2: .asciz "files/test2.txt"
output_test_path2: .asciz "files/result2.txt"
test_path_3: .asciz "files/test3.txt"
output_test_path3: .asciz "files/result3.txt"
test_path_4: .asciz "files/test4.txt"
output_test_path4: .asciz "files/result4.txt"
