section .data
        menu db 10,"1 - Cadastrar",10,"2 - Listar",10,"3 - Sair",10,"Opcao: "
        menu_len equ $ - menu

        msg_nome db "Nome Completo: "
        msg_nome_len equ $ - msg_nome

        msg_idade db "Idade Servico: "
        msg_idade_len equ $ - msg_idade

        msg_classe db "Classe (0=Soldado, 1=Cabo): "
        msg_classe_len equ $ - msg_classe

        msg_quartel db "Quartel: "
        msg_quartel_len equ $ - msg_quartel

        newline db 10

section .bss
        pessoas resb 110 * 100
        total resq 1

        buffer_nome resb 50
        buffer_idade_servico resb 4     ; 4 por causa da tabela ASCII / idade + ENTER
        buffer_classe resb 2
        buffer_quartel resb 50
        opcao resb 2

section .text
        global _start

_start:
        mov qword [total], 0

menu_loop:
        mov rax, 1
        mov rdi, 1
        mov rsi, menu
        mov rdx, menu_len
        syscall

        mov rax, 0
        mov rdi, 0
        mov rsi, opcao
        mov rdx, 2
        syscall

        mov al, [opcao]

        cmp al, "1"
        je cadastrar

        cmp al, "2"
        je listar

        cmp al, "3"
        je sair

        jmp menu_loop   ; reinicia o programa.

        ; =============================
        ;        Cadastro Da Base
        ;==============================

cadastrar:
        mov rax, [total]
        mov rcx, 110
        mul rcx         ; rax = indice * 110
        mov rdi, pessoas
        add rdi, rax    ; rdi aponta para struct atual
        
        push rdi        ; SALVA o início da struct atual na pilha

        ; Nomes
        mov rax, 1
        mov rdi, 1
        mov rsi, msg_nome
        mov rdx, msg_nome_len
        syscall

        mov rax, 0
        mov rdi, 0
        mov rsi, buffer_nome
        mov rdx, 50
        syscall

        pop rdi         ; Recupera RDI original
        push rdi        ; Salva de novo para o próximo campo
        mov rsi, buffer_nome
        mov rcx, 50
        rep movsb       ; cópia os bytes e retorna para endereço da memória apontado em RDI ( pessoas )

        ; Idade
        mov rax, 1
        mov rdi, 1
        mov rsi, msg_idade
        mov rdx, msg_idade_len
        syscall

        mov rax, 0
        mov rdi, 0
        mov rsi, buffer_idade_servico
        mov rdx, 4      ; 4 bytes por causa do ASCII ( ENTER )
        syscall

        pop rdi         ; Recupera RDI (início da struct)
        push rdi        ; Salva de novo
        mov al, [buffer_idade_servico]
        sub al, "0"               ; ex: '0' em ASCII, 0x30, '5' 0x35 - '0' 0x30 = 5
        mov [rdi + 50], al      ; guarda 1 byte ( idade ) na offset 50
                                 ; guarda o '5' na offet 50 ( deslocamento da memória )

        ; Quartel
        mov rax, 1
        mov rdi, 1
        mov rsi, msg_quartel
        mov rdx, msg_quartel_len
        syscall

        mov rax, 0
        mov rdi, 0
        mov rsi, buffer_quartel
        mov rdx, 50
        syscall

        pop rdi         ; Recupera RDI (início da struct)
        push rdi        ; Salva pela última vez
        lea rsi, [buffer_quartel]       ; carrega o endereço onde está na memória
        lea rdi, [rdi + 52]             ; calcula o endereço do buffer
        mov rcx, 50
        rep movsb                       ; copia os 50 bytes
       
        ; Número = índice
        pop rdi         ; Recupera o início da struct
        mov rax, [total]
        mov [rdi + 102], rax            ; joga o rax na offset 102

        inc qword [total]
        jmp menu_loop

        ; ===================
        ;        Listagem
        ;====================

listar:
        mov r12, [total] ; Usamos R12 pois syscall altera RCX
        cmp r12, 0
        je menu_loop

        mov rbx, 0 ; começo de um loop em 0 sem lixos.

loop_listar:
        cmp rbx, r12
        je menu_loop

        mov rax, rbx
        mov rdx, 110
        mul rdx

        mov rsi, pessoas
        add rsi, rax

        mov rax, 1
        mov rdi, 1
        mov rdx, 50
        syscall

        mov rax, 1
        mov rdi, 1
        mov rsi, newline
        mov rdx, 1
        syscall

        inc rbx
        jmp loop_listar

        ; ==============
        ;        SAIR
        ; ==============

sair:
        mov rax, 60
        xor rdi, rdi
        syscall
