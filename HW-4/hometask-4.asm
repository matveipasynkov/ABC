# Домашнее задание - 4, Пасынков Матвей, БПИ237
.data
ask: .asciz "Хотите ли вы ввести число (1 - да, 0 - нет)?: "
info: .asciz "Ещё можно ввести n чисел, где n = "
input_num: .asciz "Введите число: "
result_num: .asciz "Полученная сумма: "
count: .asciz "Случилось переполнение.\nКоличество успешно сложенных чисел: "
msg_even: .asciz "Количество чётных чисел: "
msg_odd: .asciz "Количество нечётных чисел: "
ln: .asciz "\n"
.align 2
array: .space 40
arrend:
.text
    # Заставляем пользователя ввести первое число.
    # Про желание ввести больше чисел мы спрашиваем после первого ввода.
    la t0 array
    la t1 arrend
    li t2 0
    la a0 input_num
    li a7 4
    ecall
    li a0 0
    li a7 5
    ecall
    sw a0 (t0)
    addi t0 t0 4
    addi t2 t2 1
loop:
    # Цикл ввода, срабатывающий после ввода первого числа.
    la a0 info
    li a7 4
    ecall
    sub a0 zero t2
    addi a0 a0 10
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    la a0 ask
    ecall
    li a7 5
    ecall
    beqz a0 end_loop
    la a0 input_num
    li a7 4
    ecall
    li a7 5
    ecall
    sw a0 (t0)
    addi t0 t0 4
    addi t2 t2 1
    blt t0 t1 loop
end_loop:
    la t0 array
    li s0 2
    li s1 1
    # Далее запускаем цикл подсчёта количества чётных и нечётных чисел.
odd_even_loop:
    lw a0 (t0)
    rem a0 a0 s0
    beq a0 s1 add_odd
    beqz a0 add_even
add_odd:
    addi s2 s2 1
    addi s4 s4 1
    addi t0 t0 4
    blt s4 t2 odd_even_loop
    beqz zero write_odd_even
add_even:
    addi s3 s3 1
    addi s4 s4 1
    addi t0 t0 4
    blt s4 t2 odd_even_loop
    beqz zero write_odd_even
write_odd_even:
    # Выводим полученные количества.
    la a0 msg_even
    li a7 4
    ecall
    mv a0 s3
    li a7 1
    ecall 
    la a0 ln
    li a7 4
    ecall
    
    la a0 msg_odd
    li a7 4
    ecall
    mv a0 s2
    li a7 1
    ecall 
    la a0 ln
    li a7 4
    ecall
    la t0 array
sum_loop:
    # Далее идёт цикл подсчёта суммы.
    lw a0 (t0)
    add t5 a0 t3
    bgtz a0 if_pos
    bltz a0 if_neg
    beqz a0 if_0
if_pos:
    # Проверка отрицательного переполнения.
    blt t5 t3 end_sum_loop
    mv t3 t5
    addi t4 t4 1
    addi t0 t0 4
    blt t4 t2 sum_loop
    beqz zero end_sum_loop
if_neg:
    # Проверка положительного переполнения.
    bgt t5 t3 end_sum_loop
    mv t3 t5
    addi t4 t4 1
    addi t0 t0 4
    blt t4 t2 sum_loop
    beqz zero end_sum_loop
if_0:
    # Если есть 0 в массиве.
    mv t3 t5
    addi t4 t4 1
    addi t0 t0 4
    blt t4 t2 sum_loop
    beqz zero end_sum_loop
end_sum_loop:
    # Выводим полученную сумму.
    la a0 result_num
    li a7 4
    ecall
    mv a0 t3
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    beq t4 t2 end
    # На случай, если случилось переполнение, то
    # выводим сообщение об этом и количество успешно сложенных чисел.
    la a0 count
    li a7 4
    ecall
    mv a0 t4
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
end:
    # Завершаем программу.
    li a0 0
    li a7 10
    ecall