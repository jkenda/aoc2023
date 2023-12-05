format ELF64 executable
use64

BUFSIZ equ 80000

include "asm/io.inc"

segment readable executable
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

    exit 0


; rax = parse()
parse:
    mov rax, 0
    mov rcx, 0

    ; 1st digit
    mov dil, [buffer + r13]
    mov al, dil
    inc r13
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
    add al, [buffer + r13]
    sub al, '0'
    inc r13

    ret

; goto(rdi)
goto:
    ; return if buffer overflown
    cmp r13, r14
    jge .ret

    cmp dil, [buffer + r13]
    je .ret
    inc r13
    jmp goto
.ret:
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

; puti(rdi)
puti:
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

    ret


err_overflow:
    exit 1

segment readable writeable
wbuf: rb 20
      db 10
wbptr = $
wblen dq 0

winning     rb 16
ours        rb 32
winning.len dq 0
ours.len    dq 0
buffer      rb BUFSIZ
