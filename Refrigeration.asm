section .data
    ; Mensagens fixas de aviso
    mensagem_pergunta db "Digite o nivel 1-5: ", 0
    len_mensagem_pergunta equ $ - mensagem_pergunta

    mensagem_status db "Nivel Atual: ", 0
    len_mensagem_status equ $ - mensagem_status

    nivel_refrigerador db '0' ; valor 'padrao'

section .bss
    ; Buffer referente a entrada de dados
    ; 1 byte em numero e 1 byte para tecla ENTER
    input_usuario resb 2

section .text
    global _start

_start:
    ; --- [+] Pergunta Ao Usuario ---
    mov eax, 4
    mov ebx, 1
    mov ecx, mensagem_pergunta
    mov edx, len_mensagem_pergunta
    int 0x80

    ; --- [+] Entrada de dados ---
    mov eax, 3 ; Syscall 3 read
    mov ebx, 0
    mov ecx, input_usuario
    mov edx, 2
    int 0x80

    ; --- [+] Processo de mudancas ---
    mov al, [input_usuario]
    mov [nivel_refrigerador], al

    ; --- [+] Status operacao ---
    mov eax, 4
    mov ebx, 1
    mov ecx, mensagem_status
    mov edx, len_mensagem_status
    int 0x80

    ; --- [+] Nivel de refrigeracao ---
    mov eax, 4
    mov ebx, 1
    mov ecx, nivel_refrigerador
    mov edx, 1 ; saida de 1 byte ( numero )
    int 0x80

    ; --- [+] /n da operacao ---
    mov eax, 4
    mov ebx, 1
    mov ecx, input_usuario + 1
    mov edx, 1
    int 0x80

    ; --- [+] Saida ---
    mov eax, 1
    xor ebx, ebx
    int 0x80
