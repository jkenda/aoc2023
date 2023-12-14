; ERROR CODES:
; error 1: input buffer overflow - increase BUFSIZ
; error 2: lines buffer overflow - increase MAX_LINES

format ELF64 executable
use64

BUFSIZ equ 80000
MAX_LINES equ 64
include "asm/util.inc"

segment readable executable
entry $
    read STDIN, buffer, BUFSIZ

    cmp rax, BUFSIZ
    mov rdi, 1
    je  _exit

    mov r10, rax ; len
    ;; r11 -- do not use!
    mov r12, 0   ; offset
    mov r13, 0   ; sum
    mov r14, 1   ; height
    mov r15, 0   ; width

    mov [lines + 0], 0 ; lines[0]

.loop:
    cmp r12, r10
    jge .end

    cmp byte [buffer + r12], 10
    je .newline

    inc r12
    jmp .loop

.newline:
    mov r15, r12
    sub r15, [lines + 8 * r14 - 8]
    inc r12

    cmp r14, MAX_LINES
    mov rdi, 2
    jge _exit

    ; two subsequent newlines or newline+EOF ->
    ; end of pattern
    cmp byte [buffer + r12], 10
    je .gap
    cmp r12, r10
    jge .gap

    ; still inside pattern
    mov [lines + 8 * r14], r12
    inc r14

    inc r12
    jmp .loop

.gap:
    mov rdi, roweq
    mov rsi, r14
    call find_mirror
    mov rdi, coleq
    mov rsi, r15
    call find_mirror
    pop r14
    inc r12

    ; reset
    mov r14, 1 ; nlines
    mov [lines + 0], r12 ; lines[0]

    jmp .loop

.end:
    mov rdi, r13
    call puti
    exit 0

; find_mirror(rdi = fn, rsi = width|height)
find_mirror:
    mov rbp, rdi
    mov r9, rsi
    mov rbx, 0 ; i

.loop:
    mov rcx, r9
    dec rcx
    cmp rbx, rcx
    jge .ret_0 ; i >= width|height

    lea rcx, [rbx + 0] ; upper|left
    lea rdx, [rbx + 1] ; lower|right

.inner:
    cmp rcx, 0
    jl .ret ; upper < 0
    cmp rdx, r9
    jge .ret ; lower >= nlines

    mov rdi, rcx
    mov rsi, rdx
    call rbp
    cmp rax, 0
    je .try_next

    dec rcx
    inc rdx
    jmp .inner

.try_next:
    inc rbx
    jmp .loop
    
.ret:
    lea rax, [rbx + 1]
    cmp rbp, coleq
    je .add_1x
.add_100x:
    imul rax, 100
.add_1x:
    add r13, rax
    ret

.ret_0:
    mov rax, 0
    ret

; roweq(rdi, rsi)
roweq:
    mov rdi, [lines + 8 * rdi]
    mov rsi, [lines + 8 * rsi]
    mov rax, 0

.loop:
    cmp rax, r15
    jge .ret_true

    mov r8b, [buffer + rdi + rax]
    cmp r8b, [buffer + rsi + rax]
    jne .ret_false

    inc rax
    jmp .loop

.ret_true:
    mov rax, 1
    ret

.ret_false:
    mov rax, 0
    ret

; coleq(rdi, rsi)
coleq:
    push rbx
    mov rax, 0

.loop:
    cmp rax, r14
    jge .ret_true

    mov rbx, [lines + 8 * rax]

    mov r8b, [buffer + rbx + rdi]
    cmp r8b, [buffer + rbx + rsi]
    jne .ret_false

    inc rax
    jmp .loop

.ret_true:
    pop rbx
    mov rax, 1
    ret

.ret_false:
    pop rbx
    mov rax, 0
    ret


segment readable writeable
lines     rq MAX_LINES
buffer    rb BUFSIZ
