Este projeto contém um código em Assembly (NASM) que pode ser compilado e executado em sistemas Linux.

## Pré-requisitos

Antes de tudo, certifique-se de ter o **NASM** instalado:

```bash
sudo apt install nasm -y
```

## Como compilar e executar

Siga os passos abaixo no terminal:

### 1. Compilar o código Assembly

```bash
nasm -f elf64 Refrigeration.asm -o Refrigeration.o
```

### 2. Linkar o arquivo objeto

```bash
ld Refrigeration.o -o Refrigeration
```

### 3. Executar o programa

```bash
./Refrigeration
```

## Observações

* Este projeto utiliza o formato **ELF64**, portanto é necessário um sistema compatível com 64 bits.
* Certifique-se de que o arquivo `Refrigeration.asm` está no diretório atual antes de executar os comandos.
* Caso encontre erros de permissão ao executar, utilize:

```bash
chmod +x Refrigeration
```

---
