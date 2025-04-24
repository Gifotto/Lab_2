section .bss
    input resb 256         ; Буфер для ввода строки (до 256 байт)
    count resd 1           ; Переменная для хранения результата (4 байта)

section .data
    prompt db "Введите строку чисел через пробел: ", 0 ; Сообщение для пользователя
    prompt_len equ $ - prompt                          ; Вычисление длины сообщения

    newline db 10            ; Символ перевода строки (\n)
    result_msg db "Результат: ", 0 ; Префикс перед выводом результата
    result_msg_len equ $ - result_msg

section .text
    global _start            ; Точка входа для линковщика

_start:
    ; ---------- Вывод приглашения к вводу ----------
    mov eax, 4               ; syscall number 4 = sys_write
    mov ebx, 1               ; дескриптор 1 = stdout
    mov ecx, prompt          ; адрес строки
    mov edx, prompt_len      ; длина строки
    int 0x80                 ; системный вызов

    ; ---------- Чтение строки от пользователя ----------
    mov eax, 3               ; syscall number 3 = sys_read
    mov ebx, 0               ; дескриптор 0 = stdin
    mov ecx, input           ; куда сохранять ввод
    mov edx, 256             ; макс. количество байт
    int 0x80                 ; системный вызов

    ; ---------- Инициализация указателей ----------
    mov esi, input           ; Указатель на текущую позицию в буфере
    xor edi, edi             ; Обнуляем счётчик (edi = 0)

; ------------------ Начало цикла обработки строки ------------------
next_token:

.skip_spaces:
    mov al, [esi]            ; Загружаем текущий символ
    cmp al, ' '              ; Пробел?
    je .skip_space_advance   ; Да — переходим дальше
    cmp al, 10               ; Перевод строки?
    je .print_result         ; Конец ввода — переходим к выводу
    cmp al, 0                ; Конец строки?
    je .print_result         ; Конец — выводим результат
    jmp .start_digit_check   ; Иначе — начинаем проверку числа

.skip_space_advance:
    inc esi                  ; Продвигаем указатель вперёд
    jmp .skip_spaces         ; Повторяем пока не найдём цифру

; ---------- Начало обработки одного числа ----------
.start_digit_check:
    mov bl, [esi]            ; Сохраняем первую цифру в bl
    cmp bl, '0'              ; Проверка: цифра?
    jb .skip_invalid         ; Нет — не обрабатываем
    cmp bl, '9'
    ja .skip_invalid

    inc esi                  ; Продвигаемся к следующему символу
    mov ecx, 1               ; ecx = 1 — флаг: пока все цифры одинаковы

; ---------- Сравниваем остальные цифры с первой ----------
.check_digits:
    mov al, [esi]            ; Текущий символ
    cmp al, ' '              ; Пробел = конец числа
    je .done_number
    cmp al, 10               ; Перевод строки = конец
    je .done_number
    cmp al, 0                ; Конец строки
    je .done_number

    cmp al, bl               ; Сравниваем с первой цифрой
    jne .not_same            ; Если не совпадает — флаг сбрасывается

    inc esi                  ; Переход к следующему символу
    jmp .check_digits        ; Продолжаем сравнивать

; ---------- Цифры оказались разными ----------
.not_same:
    mov ecx, 0               ; Сброс флага — цифры не одинаковы

.skip_rest:
    mov al, [esi]            ; Пропускаем оставшиеся символы числа
    cmp al, ' '
    je .done_number
    cmp al, 10
    je .done_number
    cmp al, 0
    je .done_number

    inc esi
    jmp .skip_rest           ; До конца текущего числа

; ---------- Завершили чтение одного числа ----------
.done_number:
    cmp ecx, 1               ; Флаг = 1 => все цифры одинаковы?
    jne .continue_loop
    inc edi                  ; Увеличиваем счётчик таких чисел

; ---------- Обработка следующего токена ----------
.continue_loop:
    mov al, [esi]
    cmp al, 10               ; Перевод строки?
    je .print_result
    cmp al, 0               
    je .print_result
    inc esi
    jmp next_token           ; Переход к следующему слову

; ---------- Пропускаем нецифровые символы ----------
.skip_invalid:
    inc esi
    jmp next_token

; ------------------ Печать результата ------------------
.print_result:
    ; Выводим "Результат: "
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, result_msg_len
    int 0x80

    ; Преобразуем число (edi) в символ (если число <= 9)
    mov eax, edi             ; edi = кол-во чисел
    add eax, '0'             ; Преобразуем в ASCII
    mov [input], eax         ; Пишем в буфер
    mov byte [input+1], 10   ; Добавляем \n

    ; Выводим результат (1 символ + перевод строки)
    mov eax, 4
    mov ebx, 1
    mov ecx, input
    mov edx, 2
    int 0x80

    ; Завершение работы
    mov eax, 1               ; syscall: sys_exit
    xor ebx, ebx             ; код выхода = 0
    int 0x80
