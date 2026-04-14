; ----------------------------------------------------------------------------------------------
; GOD IS ASSEMBLY LANGUAGE
; HOLY ASM - THE ORACLE INTERFACE
; COMMAND: nasm -f elf64 Holy_ASM.asm -o Holy_ASM.o && ld Holy_ASM.o -o HOLY_ASM
; ----------------------------------------------------------------------------------------------

section .data
    message_welcome db "=== WELCOME TO TEMPLE HOLY ASM ===", 10, "Press F4 for the Temple Menu", 10, 0
    message_menu    db 10, "1. HELP", 10, "2. ORACLE", 10, "SELECT: ", 0
    message_oracle  db "CHOOSE A NUMBER [1-7]: ", 0
    message_help    db "Use numbers to navigate. Seek and ye shall find.", 10, 0
    message_erro    db "Outside the bound of the Word. Try 1-7.", 10, 0
    newline         db 10, 0

    ; Biblical Verses (The Words of God)
    Genesis_c1 db "Genesis 1-2: 1.In the beginning God created the heavens and the earth. 2. Now the earth was formless and empty, darkness was over the surface of the deep, and the Spirit of God was hovering over the waters.", 10, 0
    Job_c2     db "Job 2-3: Then the LORD said to Satan, Have you considered my servant Job? There is no one on earth like him; he is blameless and upright, a man who fears God and shuns evil.", 10, 0
    Psalm_c69  db "Psalm 69-1: Save me, O God; for the waters are come in unto my soul.", 10, 0
    Psalm_c23  db "Psalm 23-1: The LORD is my shepherd; I shall not want.", 10, 0
    Psalm_c50  db "Psalm 50-1: The mighty God, even the LORD, hath spoken, and called the earth from the rising of the sun unto the going down thereof.", 10, 0
    Psalm_64   db "Psalm 64-1: Hear my voice, O God, in my prayer: preserve my life from fear of the enemy.", 10, 0
    Psalm_70   db "Psalm 70-1: Make haste, o God, to deliver me; make haste to help me o Lord.", 10, 0

    ; The Holy Jump Table
    holy_table:
        dq Genesis_c1, Job_c2, Psalm_c69, Psalm_c23, Psalm_c50, Psalm_64, Psalm_70

section .bss
    buffer resb 8 ; Espaço para entrada do usuário

section .text
    global _start

_start:
    ; Mostrar Boas-vindas
    mov rsi, message_welcome
    call print_string

main_loop:
    ; Mostrar Menu
    mov rsi, message_menu
    call print_string

    call read_input
    mov al, [buffer]

    cmp al, '1'
    je show_help
    cmp al, '2'
    je start_oracle
    
    ; Se não for 1 ou 2, limpa e volta
    jmp main_loop

show_help:
    mov rsi, message_help
    call print_string
    jmp main_loop

start_oracle:
    mov rsi, message_oracle
    call print_string

    call read_input
    call ascii_to_int ; Converte buffer para número em RAX

    ; Validar se está entre 1 e 7
    cmp rax, 1
    jl .invalid
    cmp rax, 7
    jg .invalid

    ; Buscar versículo: Endereço = holy_table + (RAX-1) * 8
    dec rax
    mov rbx, rax
    shl rbx, 3 ; Multiplica por 8 (tamanho de um ponteiro 64-bit)
    lea rcx, [holy_table]
    mov rsi, [rcx + rbx]
    
    call print_string
    jmp main_loop

.invalid:
    mov rsi, message_erro
    call print_string
    jmp main_loop

; --- SUBROTINAS SAGRADAS ---

print_string:
    push rax
    push rdi
    push rdx
    push rsi
    
    ; Calcular tamanho da string (até encontrar 0)
    mov rdx, 0
.count:
    cmp byte [rsi + rdx], 0
    je .done
    inc rdx
    jmp .count
.done:
    mov rax, 1      ; sys_write
    mov rdi, 1      ; stdout
    syscall
    
    pop rsi
    pop rdx
    pop rdi
    pop rax
    ret

read_input:
    mov rax, 0      ; sys_read
    mov rdi, 0      ; stdin
    mov rsi, buffer
    mov rdx, 8
    syscall
    ret

ascii_to_int:
    xor rax, rax
    mov rsi, buffer
.loop:
    movzx rcx, byte [rsi]
    cmp rcx, 10     ; Fim da linha [Enter]
    je .exit
    cmp rcx, '0'
    jl .exit
    cmp rcx, '9'
    jg .exit
    
    sub rcx, '0'
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp .loop
.exit:
    ret
