BUFSIZ equ 800000

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

; puti(rdi)
puti:
    push rax
    push rbx
    push rcx
    call _puti
    pop rcx
    pop rbx
    pop rax
    ret

_puti:
	push    rbx
	mov     rbx, rdi
.L3:
	test    rbx, rbx
	jns     .L2
	mov     edi, 45
	neg     rbx
	call    putc
	jmp     .L3
.L2:
	cmp     rbx, 9
	jle     .L4
	mov     rax, rbx
	mov     ecx, 10
	cqo
	idiv    rcx
	mov     rdi, rax
	call    puti
.L4:
	mov     rax, rbx
	mov     ecx, 10
	pop     rbx
	cqo
	idiv    rcx
	lea     edi, [rdx+48]
	jmp     putc

; putc(rdi)
putc:
    push rax
    push rsi
    push rdx
    push rdi
    write STDOUT, rsp, 1
    pop rdi
    pop rdx
    pop rsi
    pop rax
    ret
