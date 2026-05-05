;was getting an error: 
;"instruction not supported in 16 bit mode"
[BITS 64]
;Sarika Deol :p
global	main

section	.data
f1:	dq 7

section	.bss
;reserve a qword space in memory
f2: resq 1

section	.text

main:
	push rbp
	
	mov rax, [f1]
	add rax, 5
	mov [f2], rax
	
	pop rbp
	sub rdi, rdi
	mov rax, 60
end_syscall:
	syscall
