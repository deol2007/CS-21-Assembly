; comment
.data
sum QWORD ?
.code
main proc
	mov rax,7
	add rax,4
	mov [sum],rax
	inc rax
	mov sum,rax
	mov rsi,offset sum
	inc rax
	mov [rsi],rax
	xor ecx,ecx
	ret
main endp
end