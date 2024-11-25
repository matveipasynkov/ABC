.macro strcpy %reg_string %reg_result
    mv a0 %reg_string
    mv a1 %reg_result
    jal _strcpy
.end_macro