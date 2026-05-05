global _start

section .data
x2 dd 2.0
x3 dd 3.0
x4 dd 4.0
x5 dd 5.0
x6 dd 6.0

r1 dd 0.0
r2 dd 0.0

section .bss

section .text
_start:
	;expression 1
	fld dword[x2]
	fld dword[x6]
	fadd
	fld dword[x2]
	fdiv
	;store then pop
	fstp dword[r1]
	
	;expression 2
	fld dword[x6]
	fld dword[x3]
	fsub
	fld dword[x4]
	fld dword[x2]
	fadd
	fmul
	
	p1:
		;breakpoint
	.exit:
	mov rax, 60
	xor rdi, rdi
	syscall
