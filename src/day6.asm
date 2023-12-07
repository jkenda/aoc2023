format ELF64 executable
use64

BUFSIZ equ 80000
include "asm/io.inc"

segment readable executable
entry $
    read STDIN, buffer, BUFSIZ

    cmp rax, BUFSIZ
    mov rdi, 1
    je _exit

    mov  r10, rax       ; len
    ;; r11 -- do not use!
    mov  r12, 0         ; offset
    mov  r13, time      ; which
    mov  r14, time.len  ; which.len
    mov  r15, 1         ; prod

.loop:
    cmp r12, r10
    jge .end

    call skip_spaces
    mov al, [buffer + r12]

    cmp al, 10
    je .newline

    call is_digit
    cmp rax, 0
    jne .digit

    jmp .text

.newline:
    mov r13, dist
    mov r14, dist.len
    inc r12
    jmp .loop

.text:
    mov rdi, ':'
    call goto
    inc  r12
    jmp .loop

.digit:
    call parse

    mov rbx, [r14]
    mov [r13 + rbx], rax
    add qword [r14], 8

    jmp .loop

.end:
    call calc
    mov rdi, rax
    call puti
    exit 0


skip_spaces:
    mov rdi, 0

.next:
    ; return if buffer overflown
    cmp r12, r10
    jge .ret

    mov dil, [buffer + r12]

    cmp dil, ' '
    je .continue
    cmp dil, 9
    je .continue

    jmp .ret
.continue:
    inc r12
    jmp .next

.ret:
    ret

; rax = parse()
parse:
    ; result
    mov rcx, 0

.next:
    ; return if buffer overflown
    cmp r12, r10
    jge .ret

    ; return if not digit
    mov dil, [buffer + r12]
    call is_digit
    cmp rax, 0
    je .ret
.digit:
    imul rcx, 10
    sub  dil, '0'
    add  rcx, rdi
    inc  r12
    jmp  .next

.ret:
    mov rax, rcx
    ret

; is_digit(rdi)
is_digit:
    cmp dil, '0'
    jl .false
    cmp dil, '9'
    jg .false
.true:
    mov rax, 1
    ret
.false:
    mov rax, 0
    ret

; goto(rdi)
goto:
    ; return if buffer overflown
    cmp r12, r10
    jge .ret

    cmp dil, [buffer + r12]
    je .ret
    inc r12
    jmp goto
.ret:
    ret

; rax = calc()
; calculate the number of possible ways
; to beat the record
calc:
    ; if n. times != n. distances, then
    ; exit with error 2: wrong format
    mov rax, [time.len]
    cmp rax, [dist.len]
    mov rdi, 2
    jne _exit

    mov r12, 0 ; i

.loop:
    cmp r12, [time.len]
    jge .end

    mov rax, [time + r12] ; total time
    mov rbx, 0            ; holding time
    mov rcx, [dist + r12] ; record distance
    mov r8, 0             ; win counter

.inner:
    cmp rbx, rax
    jg .end_inner

    ; moving time
    mov rdx, rax
    sub rdx, rbx

    ; distance travelled
    imul rdx, rbx

    ; if distance is greater than record,
    ; then increase win counter
    cmp rdx, rcx
    mov rdx, 0
    setg dl
    add r8, rdx

    inc rbx
    jmp .inner

.end_inner:
    imul r15, r8

    add r12, 8
    jmp .loop

.end:
    mov rax, r15
    ret


; exit(rdi)
_exit:
    exit rdi


segment readable writeable

time     rq 32
dist     rq 32
time.len dq 0
dist.len dq 0

buffer      rb BUFSIZ
