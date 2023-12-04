format ELF64 executable
use64

segment readable executable
include "asm/io.inc"

entry $
    read STDIN, buffer, BUFSIZ
    mov [len], rax

    cmp rax, BUFSIZ
    je err_overflow

.loop:
    mov rax, [offset]
    cmp rax, [len]
    jge .ret

    mov al, [buffer + rax]

    cmp al, ' '
    je .space

    cmp al, 10
    je .newline

    mov dil, ':'
    call goto
    add [offset], 2
    jmp .next

.space:
    mov rax, [offset]
    inc rax
    mov [offset], rax
    cmp [buffer + rax], '|'
    je .pipe
    jmp .next

.pipe:
    add [offset], 2
    mov [which], ours
    mov [which.len], ours.len
    jmp .next

.newline:
    call count_points

    mov rdi, ':'
    call goto
    add [offset], 2
    mov [which], winning
    mov [which.len], winning.len
    
.next:
    call parse

    ; mov rdi, rax
    ; call puti
    ; mov rdi, ' '
    ; call putc

    ; copy number to array
    mov rbx, [which]
    mov rcx, [which.len]
    mov rdx, [rcx]
    mov [rbx + rdx], rax
    inc qword [rcx]
    jmp .loop

.ret:
    mov rdi, [sum]
    call puti
    mov rdi, 10
    call putc

    exit 0


; rax = parse()
parse:
    mov rax, 0
    mov rbx, [offset]
    mov rcx, 0

    mov dil, [buffer + rbx]
    mov al, dil
    inc rbx
    cmp al, ' '
    je .not_digit

    sub al, '0'
    imul rax, 10
    jmp .endif
.not_digit:
    mov al, 0
.endif:
    add al, [buffer + rbx]
    sub al, '0'
    inc rbx

    mov [offset], rbx
    ret

; goto(rdi)
goto:
    mov rax, [offset]
.loop:
    ; return -1 if buffer overflown
    cmp rax, [len]
    jge .ret

    cmp dil, [buffer + rax]
    je .ret
    inc rax
    jmp .loop
.ret:
    mov [offset], rax
    ret

count_points:
    mov rax, 0 ; winning index
    mov rbx, 0 ; our index
    mov r8, [winning.len]
    mov r9, [ours.len]
.winning_loop:
    mov cl, [winning + rax]

.our_loop:
    cmp cl, [ours + rbx]
    je .contains
    inc rbx
    cmp rbx, r9
    jl .our_loop
    jmp .break
.contains:
    inc [points]
.break:
    mov rbx, 0
    inc rax
    cmp rax, r8
    jl .winning_loop

    ; get shratchcard points
    mov rax, 1
    mov cl, [points]
    shl rax, cl
    shr rax, 1

    add [sum], rax

    mov [winning.len], 0
    mov [ours.len], 0
    mov [points], 0

    ret


err_overflow:
    write STDERR, err_overflow_str, err_overflow_str.len
    exit 1

segment readable
err_overflow_str db "ERROR: buffer too small", 10
err_overflow_str.len = $ - err_overflow_str

segment readable writeable

winning     rb 32
winning.len dq 0

ours     rb 32
ours.len dq 0

which dq winning
which.len dq winning.len

points db 0
sum    dq 0

len    dq 0
offset dq 0
buffer rb BUFSIZ
