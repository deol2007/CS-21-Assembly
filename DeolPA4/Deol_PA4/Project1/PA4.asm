.data
;target value
tv qword 7
be qword -1
arr qword 7,2,11,4,6,1,3,10,9
af qword -1

.code
main proc
;outer loop index (i)
xor r8, r8

;inner loop index (j)
xor r9, r9

;temp variable
xor r10, r10

;address of array
lea r11, arr

outerLoop:
	xor r9,r9

innerLoop:
    ;into the temp variable move the element at index j
    mov r10, [r11 + r9*8]
    ;move element at j+1
    mov rax, [r11 + r9*8 + 8]

    ;if rax is at -1, we hit the end of this loop
    cmp rax, -1
    je end_innerloop

    ;if r10 is not greater
    cmp r10, rax
    ;skip the the next code
    jle skip_swap

    ;move rax into the location r10 is at
    mov [r11 + r9*8], rax
    ;move r10 into the location r11 is at
    mov [r11 + r9*8 + 8], r10

;we did not swap
skip_swap:
    ;increment the j value
    inc r9
    ;jump to the start of the inner loop
    jmp innerLoop

end_innerloop:
    inc r8
    ;there are 9 element and we start at 0
    cmp r8, 8
    ;if we haven't loop through all 9, keep going
    jl outerLoop

NOP
;offset off the address
xor r9,r9
;address of array
lea r11, arr
loopFind:
    ;mov the variable into r10
    mov r10, [r11 + r9*8]
    ;if r10 is -1 end loop
    cmp r10, -1
    je loopFindEnd

    ;compare r10 to the value
    cmp r10, tv
    ;if tv is less than r10 we didn't find it
    jg loopFindEnd

    ;if equal
    je found

    ;if tv is greater keep looping
    inc r9
    jmp loopFind

loopFindEnd:
;move -1 into rax
    mov rax, -1
found:
    ;move tv into rax
    mov rax, tv

main endp
end