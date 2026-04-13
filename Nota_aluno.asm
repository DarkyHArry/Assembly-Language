; Sistema de nota de um aluno. Intuito apenas é você entender a estrutura das instruções e lógicas aplicadas.
; Comando: nasm -f elf64 Nota_aluno.asm -o Nota_aluno.o
; Comando: ld Nota_aluno.o -o Nota_aluno

section .data
        nota dq 8               ; nota = 8
        ponto_corte dq 7        ; ponto_corte = 7
                                ; Ambas são 64 bits

section .text
        global _start

_start:

        mov rax, [nota]         ; rax = 8
        mov rbx, [ponto_corte]  ; rbx = 7
        cmp rax, rbx            ; cpm aqui irá fazer uma subtração na comparação

        ; rax < rbx ( aluno reprova direto )
        ; JL ( Jump if Less ), Pula se menor
        jl reprovado

        ; caso não pule, RAX é maior
        call registrar_aprovacao
        jmp finalizar           ; pula para fim da instrução

        ; temos 3 labels ( rótulos )

reprovado:
        call registrar_aprovacao
        ; Não necessitamos de "jmp finalizar" aqui, por padrão o Assembly irá sair da instrução.

finalizar:
        mov rax, 60
        xor rdi, rdi    ; RDI passa ser 0
        syscall

registrar_aprovacao:
        ; Função de registro de aprovação
        mov r10, 1      ; apenas sinalizador para R10
        ret             ; retorno para call
