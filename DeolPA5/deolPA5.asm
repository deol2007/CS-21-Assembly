global main
section .data
s1 db 'hello'
s1d db 'xxxxxxxxxx'
s2 db 'goodbye',0
s2d db 'xxxxxxxxxxxxx'
s3 db 'aaaaa'
s4 db 'b'
s5 db 'ccc'
s6 db 'xxxxxxxxxxxxxx'

section .text
main:
; prolog code

; set up for call to strncpy
    mov rdi,s1d
    mov rsi,s1
    mov rdx,5
    call strncpy
    
b1:
; set up for call to strcpy
    mov rdi,s2d
    mov rsi,s2
    call strcpy

b2:
; set up for call to strcombine
    mov    rdi,s3
    mov rsi,5
    mov rdx,s4
    mov rcx,1
    mov r8,s5
    mov r9,3
    mov rax,s6
    push rax ; 7th parm
    sub rsp,8 ; room for 8th parm
    call strcombine

b3:
    pop rax

b4:
    add rsp,8 ; finish stack cleanup
    ; exit to OS
    mov rax,60
    xor rdi,rdi
    syscall

strncpy:
    push rbp
    mov rbp,rsp
    ;rdi and rsi are parameters that parameters are auto-placed in
    
    ;all we need to do is make sure that the counter is in rcx not rdx
    ;the rest of the code is done for us
    mov rcx, rdx
    ;rep movsb will move all the bytes from rsi to rdi for rcx many bytes
    rep movsb
    pop rbp
    ret
    
strcpy:
    push rbp
    mov rbp,rsp
    
    loop1:
    ;we sadly don't have a counter 
    ;so we have to solve this the lame way
    mov al, [rsi]
    mov [rdi],al
    inc rsi ;increment by a byte
    inc rdi
    
    ;0 is our "null character"
    ;if the difference between al and 0 is zero , al is 0
    cmp al,0
    jnz loop1
    
    pop rbp
    ret

strcombine:
    push rbp
    mov rbp, rsp
    ;we want to use the movsb, so we need to store registers
    ;rdi, rsi, and rcx need to store the values for each copy
    ;so all the other values must be stored in other registers
    
    mov r10, rdi
    mov r11, rsi
    mov r12, rdx
    mov r13, rcx
    mov r14, r8
    mov r15, r9

    mov rbx, qword [rbp+24]

    ;counter is the length of s3
    mov rcx, r11
    ;source is s3 string
    mov rsi, r10
    ;destination is rbx
    mov rdi, rbx
    ;we repeat for length of s3 many times
    rep movsb

    ;counter is length of s4
    mov rcx, r13
    ;source is the s4 string
    mov rsi, r12

    ;we repeat for length of s4 many times
    rep movsb
    
    ;counter is length of s5
    mov rcx, r15
    ;source is s5
    mov rsi, r14

    ;repeat length of s5 many times
    rep movsb
   
    ;rax is storing the combined length,
    ;we can just add together the length variables
    mov rax, r11
    add rax, r13
    add rax, r15
    mov qword [rbp+16], rax
    
    mov rsp, rbp
    pop rbp
    ret

