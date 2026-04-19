; =======================================================================================
;
;              Microcontrolador X86_64 ( Simulador de temperatura )
;
; =======================================================================================

section .data
        msg_microcontrolador db "Microcontrolador Temperatura", 0xA, 0
        tam_msg_microcontrolador equ $ - msg_microcontrolador

        msg_alerta db "ALERTA: Superaquecimento!", 0xA, 0
        len_msg_alerta equ $ - msg_alerta

        msg_normal db "Sistema Estável!", 0xA, 0
        tam_msg_normal equ $ - msg_normal

        temperatura_limite dd 80 ; Limite temperatura é 80.

section .text
        global _start

_start:
        mov rax, 1
        mov rdi, 1
        mov rsi, msg_microcontrolador
        mov rdx, tam_msg_microcontrolador
        syscall

        mov eax, 80 ; valor para ser alterado e ver as mensagens avisando!
        mov ebx, 5

        cmp eax, [temperatura_limite]
        jg alerta
        jmp normal



alerta:
        mov rsi, msg_alerta
        mov rdx, len_msg_alerta
        jmp imprimir

normal:
        mov rsi, msg_normal
        mov rdx, tam_msg_normal

imprimir:
        mov rax, 1
        mov rdi, 1
        syscall

        mov rax, 60
        xor rdi, rdi
        syscall
