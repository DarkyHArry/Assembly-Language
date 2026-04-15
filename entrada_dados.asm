; ===================================================================================================================================================
; Comandos: nasm -f elf64 entrada_dados.asm -o  entrada_dados.o && ld entrada_dados.o -o entrada_dados && clear && ./entrada_dados
; ===================================================================================================================================================
; Tutorial de ensino como fazer entrada de dados de um usuário e imprimir junto a uma mensagem tal "string".
; ===================================================================================================================================================
section .data
        prompt   db "Seu nome: ", 0
        len_prompt equ $ - prompt

        greeting db "Olá, ", 0
        len_greeting equ $ - greeting

section .bss
        nome resb 32    ; reservamos 32 bytes para o pegar o nome do usuário

section .text
        global _start

_start:
        call putPrompt  ; chama o rótulo para entrada de dados
        call readName   ; chama o leitor de entrada de dados
        call putGreeting
        call putName
        call exit

putPrompt:
        mov rax, 1
        mov rdi, 1
        mov rsi, prompt
        mov rdx, len_prompt
        syscall
        ret

readName:               ; entrada de dados do usuário
        mov rax, 0
        mov rdi, 0
        mov rsi, nome
        mov rdx, 32     ; 32 bytes declarados na .bss
        syscall
        ret

putGreeting:
        mov rax, 1
        mov rdi, 1
        mov rsi, greeting
        mov rdx, len_greeting
        syscall
        ret

putName:
        mov rax, 1
        mov rdi, 1
        mov rsi, nome
        mov rdx, 32
        syscall

exit:
        mov rax, 60
        xor rdi, rdi
        syscall
