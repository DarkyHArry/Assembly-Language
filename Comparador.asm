; Ao rodar essas instruções certifique-se de rodar no terminal: echo $? se 0, funcionou com sucesso!
; O foco dessa instruição é entender FLAGS, JUMPS e CALL em ASM x86_64
; cmp rax, rbx faz uma comparação e subtrai sem salvar valor algums. 
; se ZF=0 rax e rbx são diferentes / se ZF=1 rax e rbx são iguais
; comandos: nasm -f elf64 Comparador.asm -o Comparador.o
; comandos: ld Comparador.o -o Comparador

section .data
        valor1 dq 10    ; constante de 64 bits ( Quadword ) valor: de 10.
        valor2 dq 10    ; constante de 64 bits ( Quadword ) valor de 10.

section .text
        global _start

_start:

        ; --- Carregar valores nos registradores ---
        mov rax, [valor1]       ; Carrega 10 em registrador RAX (valor1).
        mov rbx, [valor2]       ; Carrega 10 em registradir RBX (valor2).

        ; ---- Comparação e Flags ---
        cmp rax, rbx            ; Comparamos RAX e RBX para ajuste de FLAGS

        ; --- Jumps ---
        jne valores_diferentes  ; Pula se não for igual / ZF=0 ( diferentes ), pula.
                                ; Se forem iguais ZF=1, ele NÂO pula e segue abaixo.
                                ; ZF=0 diferente / ZF=1 iguais.

        ; --- Chamada de funcão ---
        call func_se_igual      ; Chama "func_se_igual" no fim da instrução.
        jmp saida_instrucao     ; Pulo incondicional para não executar o erro por acidente.

valores_diferentes:
        nop                     ; nop ( No Operations ), não faça nada!.

saida_instrucao:
        mov rax, 60
        xor rdi, rdi
        syscall

        ; --- funcao "func_se_igual" para operação em resposta aritmética
func_se_igual:
        add rax, 5              ; RAX = 5 para exemplo
        ret                     ; ret é retormo para linha após 'call'
