.data
sum1 QWORD ?
sum2 QWORD ?
sum3 QWORD ?

arr dq 10,4,6,15,9,3,7

.code
main proc
;loop1, count-up loop
    xor r8, r8             ; store address
    xor r9, r9             ; store value in array
    xor r10, r10           ; add sum
    xor r11, r11           ; store compare address

    lea r8, arr            ; address of first element
    lea r11, arr + (7*8)   ; address of last element in array

loopsum1:
    cmp r8, r11            ; check if we've reached end of array
    jge endloopsum1

    mov r9, [r8]           ; store the element that r8 points to
    add r10, r9            ; add to r10

    add r8, 8              ; move to next element
    jmp loopsum1           ; back to the top of loop

endloopsum1:
    mov sum1, r10          ; store in sum1



;loop2 count-down loop
    xor r8,r8              ; address for first element
    xor r9,r9              ; store value in array
    xor r10,r10            ; add sum
    ; r11 already has the last address 

    lea r8, arr

loopsum2:
    cmp r11, r8            ; are we at the start of array
    jl endloopsum2         ; jump if r11 is less than the first element position

    mov r9, [r11]          ; store the element that r11 points to
    add r10, r9            ; add r9 to r10

    sub r11, 8             ; decrement by a byte
    jmp loopsum2           ; back to the top of the list

endloopsum2:
    mov sum2, r10          ; store r10 in sum2

    nop

;loop3
    ;r8 already contains the first element of the array
    xor r9, r9             ; store value in array
    xor r10, r10           ; add sum
    xor r11, r11           ; store offset

loopsum3:
    cmp r11, (7*8)         ; 7 elements, each 8 bytes -> (7*8) offset
    je endloopsum3         ; jump is offset is 56

    mov r9, [r8+r11]       ; store the contents at the address plus offset
    add r10, r9            ; add r9 to total in r10

    add r11, 8             ; increment by a byte
    jmp loopsum3           ; back to the top of loop


endloopsum3:
    mov sum3, r10          ; store r10 in sum3

main endp
end