;_start is where is function we are running first
;I'm not sure why, but when I used "main" as the function instead it was giving me the error that it didn't know where to start running
global _start

section .data
;these are all the strings we are going to say to the user
;each of these needs to be store in an operand so that we can pass to the OS functions
prompt_student db "Enter student number (0-14, -1 to quit): ",10,0
prompt_grade   db "Enter grade number (0-11): ",10,0
msg_result     db "The grade was ",0
msg_exit       db "Thanks and have a great day!",10,0
;create a operand that stores the newline (so that it is easier to read/understand)
;10 is the same as 0ah
newline        db 10

;our array of grade
grarray dw 85,23,67,49,10,69,11,64,24,72,14,16
        dw 34,53,45,100,93,14,73,89,63,12,67,99
        dw 68,32,82,91,16,1,100,3,41,43,2,5
        dw 84,30,55,38,33,74,57,90,17,81,11,14
        dw 4,88,9,6,21,18,62,15,71,19,98,97
        dw 27,51,94,36,26,76,97,37,56,52,62,63
        dw 95,60,40,39,20,65,5,37,57,8,66,99
        dw 7,49,61,53,48,44,67,43,83,91,12,16
        dw 94,38,1,35,52,64,54,10,93,31,86,82
        dw 3,36,95,20,96,4,92,80,89,56,7,14
        dw 76,60,26,47,29,66,70,87,100,72,72,73
        dw 84,30,78,17,58,13,45,79,82,75,90,91
        dw 55,77,9,23,88,32,18,59,25,62,31,39
        dw 41,12,2,39,71,86,24,65,34,97,16,22
        dw 51,98,85,99,14,69,74,68,5,22,8,77

section .bss
;we need to reserve space for where the input is going
inbuffer  resb 64
;reserve space for the output we are giving to the user
outbuffer resb 16

section .text
_start:
.loop:
    ; rsi stores the message we will print to user
    mov rsi, prompt_student
    ;print_string function will print the string in rsi
    call print_string

    ;read student input
    call read_int
    
    ;store number in ebx
    mov ebx, eax
    ;make sure the number isn't negative
    cmp ebx, -1
    ;if the number is negative, exit
    je .exit

    ; bounds check student 0 to 14
    cmp ebx, 0
    jl .exit
    cmp ebx, 14
    jg .exit

    ; ask user for grade
    mov rsi, prompt_grade
    call print_string

    ; read grade given by user
    call read_int
    ;move the input into ecx
    mov ecx, eax
    ;check if the input is lower than 0 or greater than 11
    cmp ecx, 0
    jl .exit
    cmp ecx, 11
    jg .exit

    ; offset = (student*12 + grade) * 2
    
    ;move the student number back into eax
    mov eax, ebx
    ;muliply the student number elements in each row to find the column they should be in
    imul eax, 12
    ;add eax to the grade they are in
    add eax, ecx
    ;muliply by 2 because each number has 2 digits
    shl eax, 1
    ;we will move the value into eax
    movzx eax, word [grarray + rax]

    ;move the size of output buffer into rdi
    mov rdi, outbuffer
    ;move the  score into ebx
    mov ebx, eax
    ;call to change the score into a string we can output
    call int_to_ascii

    ; print "The grade was " 
    mov rsi, msg_result
    call print_string
    ;print the grade
    mov rsi, outbuffer
    call print_string

    ; newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
	
	;keep looping
    jmp .loop

;our exit code
.exit:
    mov rsi, msg_exit
    call print_string
    ;60 is the function number to end the program
    mov rax, 60
    xor rdi, rdi
    syscall

;***non-main functions start here***

;this function will use the read OS function to read all input
read_int:
	;in a read the function number is 0
    mov rax, 0
    ;STDIN
    mov rdi, 0
    ;the buffer length
    mov rsi, inbuffer
    ;length of read
    mov rdx, 64
    ;do our read
    syscall
	
	;move the value of the input buffer into rsi again
    mov rsi, inbuffer
    ;clear eax
    xor eax, eax
    ;edi = 1 makes the sign positive
    mov edi, 1

convert:
	;loading a character from the input buffer
    mov dl, [rsi]
    ;check if the character is a newline, this indicates the end of the input
    cmp dl, 10
    ;if we read an enter it is over
    je .done
    ;take the difference between 0 and the number
    sub dl, '0'
    ;eax is holding our value
    ;by multiplying by 10 we are doing the same thing as a shift left
    imul eax, 10
    ;add the new smallest digit
    add eax, edx
    ;move onto the next character
    inc rsi
    ;repeat loop
    jmp convert

.done:
    ret

;convert an int back into ascii
int_to_ascii:
	;we have a special case for when the score is 100 because it is 3 digits
    cmp ebx, 100
    ;if not 100, jump to not 100
    jne .not100
    ;byte by byte we need to move 100 into rdi
    mov byte [rdi], '1'
    mov byte [rdi+1], '0'
    mov byte [rdi+2], '0'
    mov byte [rdi+3], 0
    ;then we can just return because we are done
    ret
;if not 100
.not100:
	;copy the int into eax
    mov eax, ebx
    ;clear edx
    xor edx, edx
    ;ecx is our divisor
    mov ecx, 10
    ;divide eax/ecx and put the answer in eax
    div ecx
    ;is eax is 0...
    cmp eax, 0
    ;we have 1 digit
    jne .two_digits
    ; otherwise we have one digit
    ;add the diff offset from '0' to dl
    add dl, '0'
    ;move the digit into rdi
    mov byte [rdi], dl
    ;place a 0 after, to make it a c-string
    mov byte [rdi+1], 0
    ;one digit so we can return
    ret
;we have 2 digits
.two_digits:
	;store the 10's place in BL
    mov bl, al
    ;convert the 10's place we got to ascii
    add bl, '0'
    ;store the 10's place
    mov byte [rdi], bl
    ;dl has the reminder
    ;convert to ascii
    add dl, '0'
    ;store the 1's digit after the 10's digit
    mov byte [rdi+1], dl
	;add the null character
    mov byte [rdi+2], 0
    ;we are done :)
    ret

;print string will print rsi
print_string:
	;first we want to push rsi to the stack
    push rsi
    ;strlen will give us the length of the string in rax
    call strlen
    ;rdx will store the length of the string to be printed
    mov rdx, rax
    ;we are doing a sys_write to print the string
    mov rax, 1
    mov rdi, 1
    ;we need to pop rsi to return the stack to original state
    pop rsi
    ;syscall for write
    syscall
    ret

strlen:
;set rax to zero
    xor rax, rax
.len:
	;the start of the string + rax
	;the value should be 0 when you hit the because this is a c string
    cmp byte [rsi + rax], 0
    ;if we are at the end, jump to done
    je .done
    ;otherwise increment the accumulator (rax)
    inc rax
    ;jump to the top of loop
    jmp .len
.done:
	;rax contains the length so we can just return
    ret


