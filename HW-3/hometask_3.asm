.data
ask: .asciz "Вы хотите запустить автоматическое тестирование программы (1 - да, 0 - нет)?: "
divis: .asciz "Введите делимое: "
divid: .asciz "Введите делитель: "
result_quot: .asciz "Частное: "
ln: .asciz "\n"
result_rem: .asciz "Остаток: "
error: .asciz "На 0 делить нельзя."
stop: .asciz "Программа завершена."
info_divis: .asciz "Введённое делимое: "
info_divid: .asciz "Введённый делитель: "
msg_of_next_test: .asciz "----Следующий тест----\n"
repeat_solution: .asciz "Хотите ли вы повторить работу программы (1 - да, 0 - нет)?: "
.text
main:
    # Спрашиваем, хочет ли пользователь реализовать автоматическое тестирование.
    la a0 ask
    li a7 4
    ecall
    li a0 0
    li a7 5
    ecall
    beqz a0 self
    li t0 1
    li s1 1
    li s2 2
    li s3 3
    li s4 4
    li s5 5
    li s6 6
test1: # Делимое положительное, делитель отрицательный.
    la a0 info_divis
    li a7 4
    ecall
    li a0 7
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    la a0 info_divid
    li a7 4
    ecall
    li a0 -3
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    li t1 7
    li t2 -3
    beqz zero prog
test2: # Два числа больше 0.
    la a0 msg_of_next_test
    li a7 4
    ecall
    la a0 info_divis
    ecall
    li a0 4
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    la a0 info_divid
    li a7 4
    ecall
    li a0 10
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    li t1 4
    li t2 10
    beqz zero prog
test3: # Делимое меньше 0, делитель больше 0.
    la a0 msg_of_next_test
    li a7 4
    ecall
    la a0 info_divis
    ecall
    li a0 -2
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    la a0 info_divid
    li a7 4
    ecall
    li a0 10
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    li t1 -2
    li t2 10
    beqz zero prog
test4: # Два числа меньше 0.
    la a0 msg_of_next_test
    li a7 4
    ecall
    la a0 info_divis
    ecall
    li a0 -3
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    la a0 info_divid
    li a7 4
    ecall
    li a0 -5
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    li t1 -3
    li t2 -5
    beqz zero prog
test5: # Первое число - 0, второе - любое.
    la a0 msg_of_next_test
    li a7 4
    ecall
    la a0 info_divis
    ecall
    li a0 0
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    la a0 info_divid
    li a7 4
    ecall
    li a0 4
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    li t1 0
    li t2 4
    beqz zero prog
test6: # Первое число - любое, второе - 0.
    la a0 msg_of_next_test
    li a7 4
    ecall
    la a0 info_divis
    ecall
    li a0 2
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    la a0 info_divid
    li a7 4
    ecall
    li a0 0
    li a7 1
    ecall
    la a0 ln
    li a7 4
    ecall
    
    li t1 2
    li t2 0
    beqz zero prog
self:
    # Выводим сообщение "Введите делимое: " и ожидаем ввод, сохраняем число в t1
    la a0 divis
    li a7 4
    ecall
    li a0 0
    li a7 5
    ecall
    mv t1 a0
    #  Выводим сообщение "Введите делитель: " и ожидаем ввод, сохраняем число в t2
    la a0 divid
    li a7 4
    ecall
    li a0 0
    li a7 5
    ecall
    mv t2 a0
    # Ищем, какие из двух чисел положительные, а какие отрицательные.
    # Модули делимого и делителя сохраняем в t1 и t2, вместо изначальных.
    # В t5 сохраняем знак первого числа, в t6 - второго.
prog:
    li s0 -1
    beqz t2 del_0
    beqz t1 result
    bgez t1 if_pos
    blez t1 else
if_pos:
    li t5 1
    blez t2 neg_1
    li t6 1
    blt t1 t2 end_loop
    bgez t2 loop
else:
    sub t1 zero t1
    li t5 -1
    blez t2 neg_1
    li t6 1
    blt t1 t2 end_loop
    bgez t2 loop
neg_1:
    sub t2 zero t2
    li t6 -1
    blt t1 t2 end_loop
    # Цикл, где мы вычитаем делитель из делимого, пока делимое не станет меньше делителя.
    # Остаток записываем в t4, а частное в t3.
loop:
    sub t1 t1 t2
    sub t3 t3 s0
    bge t1 t2 loop
end_loop:
    # Восстанавливаем правильные знаки частного и остатка.
    mv t4 t1
    bgez t5 if_pos_2
    blez t5 else_2
if_pos_2:
    blez t6 pos_neg
    bgez t6 result
else_2:
    blez t6 neg_neg
    bgez t6 neg_pos
pos_neg:
    sub t3 zero t3
    beqz zero result
neg_neg:
    sub t4 zero t4
    beqz zero result
neg_pos:
    sub t3 zero t3
    sub t4 zero t4
    beqz zero result
del_0:
    # Случай, если пользователь делит на 0.
    la a0 error
    li a7 4
    ecall
    la a0 ln
    ecall
    beqz zero ask_to_repeat
result:
    # Вывод частного.
    la a0 result_quot
    li a7 4
    ecall
    li a7 1
    mv a0 t3
    ecall
    la a0 ln
    li a7 4
    ecall
    # Вывод остатка.
    la a0 result_rem
    li a7 4
    ecall
    li a7 1
    mv a0 t4
    ecall
    la a0 ln
    li a7 4
    ecall
    bgtz t0 next_test
    beqz zero ask_to_repeat
next_test: # Переключение на следующий тест.
    sub t0 t0 s0
    li t1 0
    li t2 0
    li t3 0
    li t4 0
    li t5 0
    li t6 0
    ble t0 s2 test2
    ble t0 s3 test3
    ble t0 s4 test4
    ble t0 s5 test5
    ble t0 s6 test6
ask_to_repeat:
    la a0 repeat_solution
    li a7 4
    ecall
    li a0 0
    li a7 5
    ecall
    beqz a0 end
clear_reg:
    li t0 0
    li t1 0
    li t2 0
    li t3 0
    li t4 0
    li t5 0
    li t6 0
    li s0 0
    li s1 0
    li s2 0
    li s3 0
    li s4 0
    li s5 0
    li s6 0
    beqz zero main
end:
    # Завершение программы.
    la a0 stop
    li a7 4
    ecall
    la a0 ln
    ecall
    li a7 10
    li a0 0
    ecall