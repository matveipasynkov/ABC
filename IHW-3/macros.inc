# Macro for _input
# input - register, which stores data's address.
# output - nothing.
.macro input %reg_data
    mv a0 %reg_data
    jal _input
.end_macro

# Macro for _print
# input - register, which stores result data's address
# output - nothing.
.macro print %reg_data
    mv a0 %reg_data
    jal _print
.end_macro

# Macro for _process_string
# input - two registers: first stores data's address, second stores output_data's address.
# output - nothing.
.macro process_string %data_reg %output_data_reg
    mv a0 %data_reg
    mv a1 %output_data_reg
    jal _process_string
.end_macro

# Macro for _remove_newline_prog
# input - two registers: first stores data's address, second stores type of data.
# output = nothing.
.macro remove_newline_prog %data_reg %type
    mv a0 %data_reg
    mv a1 %type
    jal _remove_newline_prog
.end_macro

# Macro for _print_in_console
# input - register, which stores result data's address.
# output - nothing.
.macro print_in_console %data_reg
    mv a0 %data_reg
    jal _print_in_console
.end_macro  

# Macro for _run_test_read
# input - register, which stores path for test data and second register, which stores data's address.
# output - nothing.
.macro run_test_read %reg_path %data_reg
    mv a0 %reg_path
    mv a1 %data_reg
    jal _run_test_read
.end_macro

# Macro for _run_test_write
# input - register, which stores path for result of test and second register, which stores result data's address.
# output - nothing.
.macro run_test_write %reg_path %data_reg
    mv a0 %reg_path
    mv a1 %data_reg
    jal _run_test_write
.end_macro

# Macro for _clear_data
# input - register, which stores data's address and second register, which stores output data's address.
.macro clear_data %reg_data %reg_output_data
    mv a0 %reg_data
    mv a1 %reg_output_data
    jal _clear_data
.end_macro

# Macro, which loads necessary constants.
# input - nothing.
# output - nothing.
.macro load_constants
    li s0 'A'
    li s1 'Z'
    li s2 'a'
    li s3 'z'
    li s4 32
    li s5 0
    li s8 10240
    li s10 -1
.end_macro

# Macro, which clears necessary constants.
# input - nothing.
# output - nothing.
.macro clear_constants
    li s0 0
    li s1 0
    li s2 0
    li s3 0
    li s4 0
    li s5 0
    li s8 0
    li s10 0
.end_macro
