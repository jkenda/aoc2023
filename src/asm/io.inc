STDIN  equ 0
STDOUT equ 1
STDERR equ 2

READ   equ 0
WRITE  equ 1
EXIT   equ 60

macro read fd, buf, len
{
    mov rax, READ
    mov rdi, fd
    mov rsi, buf
    mov rdx, len
    syscall
}

macro write fd, buf, len
{
    mov rax, WRITE
    mov rdi, fd
    mov rsi, buf
    mov rdx, len
    syscall
}

macro exit code
{
    mov rax, EXIT
    mov rdi, code
    syscall
}
