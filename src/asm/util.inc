STDIN  equ 0
STDOUT equ 1
STDERR equ 2

READ   equ 0
WRITE  equ 1
EXIT   equ 60

macro read fd, buf, len
{
    mov rsi, buf
    mov rdx, len
    mov rax, READ
    mov rdi, fd
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

macro putc char
{
    push char
    write STDOUT, rsp, 1
    add rsp, 8
}

segment readable executable

; puti(rdi)
puti:
    push rax
    push rbx
    push rcx
    push rdx
    push rdi

    mov rax, rdi            ; number
    mov rbx, 10             ; radix
    lea rcx, [wbptr - 2]    ; (char*) next

    cmp  rax, 0
    setl dil    ; dil = (number < 0)
    jge  .loop  ; if (number < 0)
    neg  rax    ;     number = -number
.loop:
    cdq
    div rbx
    add dl, '0'
    mov [rcx], dl
    dec rcx

    cmp rax, 0
    jne .loop

    cmp dil, 0
    je .plus

.minus:
    mov byte [rcx], '-'
    dec rcx
.plus:
    inc rcx
    mov rdx, wbptr
    sub rdx, rcx
    write STDOUT, rcx, rdx

    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret


; exit(rdi)
_exit:
    exit rdi


segment readable writeable
wbuf: rb 20
      db 10
wbptr = $
wblen dq 0
