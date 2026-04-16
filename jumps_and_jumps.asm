section .data
        valor1 dq 8
        valor2 dq 8

        texto_maior db "O resultado é maior que 10", 0xA, 0
        len_texto_maior equ $ - texto_maior

        texto_menor db "O resultado é menor que 10", 0xA, 0
        len_texto_menor equ $ - texto_menor
        ;  a soma deve ser 16

section .bss
        resultado resq 1 ; reserva o resultado

section .text
        global _start

_start:
        mov rax, [valor1]
        mov rbx, [valor2]
        add rax, rbx

        cmp rax, 10
        jg jump_maior
        jl jump_menor
        jmp exit

jump_maior:
        mov rax, 1
        mov rdi, 1
        mov rsi, texto_maior
        mov rdx, len_texto_maior
        syscall
        jmp exit

jump_menor:
        mov rax, 1
        mov rdi, 1
        mov rsi, texto_menor
        mov rdx, len_texto_menor
        syscall
        jmp exit

exit:
        mov rax, 60
        xor rdi, rdi
        syscall
