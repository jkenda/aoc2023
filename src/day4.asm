format ELF64 executable
use64

segment readable executable
include "asm/io.inc"

entry $
    read STDIN, buffer, BUFSIZ

    cmp rax, BUFSIZ
    je err_overflow

    mov r10, 0           ; points
    mov r11, winning     ; which
    mov r12, winning.len ; which.len
    mov r13, 0           ; offset
    mov r14, rax         ; len
    mov r15, 0           ; sum

.loop:
    cmp r13, r14
    jge .ret

    mov al, [buffer + r13]

    cmp al, ' '
    je .space

    cmp al, 10
    je .newline

    mov dil, ':'
    call goto
    add r13, 2
    jmp .next

.space:
    inc r13
    cmp [buffer + r13], '|'
    je .pipe
    jmp .next

.pipe:
    add r13, 2
    mov r11, ours
    mov r12, ours.len
    jmp .next

.newline:
    call count_points

    ; skip label and reset
    mov rdi, ':'
    call goto
    add r13, 2
    mov r11, winning
    mov r12, winning.len
    
.next:
    ; parse number
    call parse

    ; copy number to array
    mov rcx, [r12]
    mov [r11 + rcx], rax
    inc qword [r12]
    jmp .loop

.ret:
    ; print sum
    mov rdi, r15
    call puti
    mov rdi, 10
    call putc

    exit 0


; rax = parse()
parse:
    mov rax, 0
    mov rbx, r13
    mov rcx, 0

    ; 1st digit
    mov dil, [buffer + rbx]
    mov al, dil
    inc rbx
    cmp al, ' '
    je .not_digit
.digit:
    sub al, '0'
    imul rax, 10
    jmp .endif
.not_digit:
    mov al, 0
.endif:
    ; 2nd digit
    add al, [buffer + rbx]
    sub al, '0'
    inc rbx

    mov r13, rbx
    ret

; goto(rdi)
goto:
    mov rax, r13
.loop:
    ; return if buffer overflown
    cmp rax, r14
    jge .ret

    cmp dil, [buffer + rax]
    je .ret
    inc rax
    jmp .loop
.ret:
    mov r13, rax
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
    inc r10
.break:
    mov rbx, 0
    inc rax
    cmp rax, r8
    jl .winning_loop

    ; get shratchcard points
    mov rax, 1
    mov cl, r10b
    shl rax, cl
    shr rax, 1

    ; add points to sum
    add r15, rax

    ; reset
    mov [winning.len], 0
    mov [ours.len], 0
    mov r10, 0

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

buffer rb BUFSIZ