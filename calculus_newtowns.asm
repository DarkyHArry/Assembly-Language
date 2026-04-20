section .data
        msg_massa  db "Digite a massa(inteiro)> ", 0
        len_massa  equ $ - msg_massa
        msg_acc    db "Aceleração: fixa definida: 10 m/s^2", 10, 0
        len_acc    equ $ - msg_acc
        msg_result db "Força calculada(Newtowns)> ", 0
        len_result equ $ - msg_result

        aceleracao dq 5 ; "constante" física

section .bss
        input_buffer resb 16
        resultado    resb 16

section .text
        global _start

_start:
        ; Aqui pegamos a massa
        mov rax, 1
        mov rdi, 1
        mov rsi, msg_massa
        mov rdx, len_massa
        syscall

        mov rax, 0
        mov rdi, 0
        mov rsi, input_buffer
        mov rdx, 16
        syscall
        ; =======================

        ; Conversão ASCII para número
        ; Carcter "5" para número 5
        xor rax, rax
        mov rsi, input_buffer

converter_loop:
        movzx rcx, byte [rsi] ; Pega o caractere digitado EXATO
        cmp rcx, 10
        je do_math
        sub rcx, 48           ; subtrai 48 - valor digitado | 48 em ASCII é 0 ou seja, sub rcx, 0
        imul rax, 10          ; multiplica o total atual por 10
        add rax, rcx          ; soma o novo digito
        inc rsi               ; vai para o proximo caractere
        jmp converter_loop

do_math:
        ; RAX na lógica deve ter o valor númerico da massa!
        ; imul rax, [aceleracao] ; rax = massa * 10

        mov rdi, resultado
        add rdi, 15
        mov byte [rdi], 10
        mov rbx, 10

reverse_convert:
        dec rdi
        xor rdx, rdx
        div rbx
        add dl, 48
        mov [rdi], dl
        test rax, rax
        jnz reverse_convert

        mov rsi, rdi
        mov rax, 1
        mov rdi, 1
        mov rdx, 16
        syscall

        mov rax, 60
        xor rdi, rdi
        syscall
