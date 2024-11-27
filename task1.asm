section .bss
    input_buffer resb 10      ; Space for user input (10 bytes max)

section .data
    message_prompt db "Enter the number: ", 0  ; Input prompt
    message_positive db "POSITIVE", 0       ; Positive message
    message_negative db "NEGATIVE", 0       ; Negative message
    message_zero db "ZERO", 0               ; Zero message

section .text
    global _start

_start:
    ; Display input prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, message_prompt
    mov edx, 15
    int 0x80

    ; Read user input
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 10
    int 0x80

    ; Convert ASCII to integer
    movzx eax, byte [input_buffer]
    sub eax, '0'

    ; Check number type
    cmp eax, 0
    je label_zero
    jg label_positive
    jl label_negative

label_positive:
    ; Display "POSITIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, message_positive
    mov edx, 8
    int 0x80
    jmp label_exit

label_negative:
    ; Display "NEGATIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, message_negative
    mov edx, 8
    int 0x80
    jmp label_exit

label_zero:
    ; Display "ZERO"
    mov eax, 4
    mov ebx, 1
    mov ecx, message_zero
    mov edx, 4
    int 0x80

label_exit:
    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

    
 
; Documentation
; -------------------------------------------------
; 1. `cmp eax, 0`: Compares the input number with 0. 
;    This sets processor flags used by conditional jumps to classify the number as zero, positive, or negative.

; 2. `je label_zero`: Jumps to the `label_zero` if the number is 0. 
;    This is determined by the zero flag being set after `cmp eax, 0`. 
;    The "ZERO" message is printed, skipping checks for positive or negative.

; 3. `jg label_positive`: Jumps to `label_positive` if the number is greater than 0. 
;    This is based on the comparison setting flags indicating the number is positive. 
;    The program prints "POSITIVE" and skips further checks.

; 4. `jl label_negative`: Jumps to `label_negative` if the number is less than 0. 
;    The jump occurs when the comparison sets flags indicating a negative number. 
;    The "NEGATIVE" message is printed without checking other cases.

; 5. `jmp label_exit`: An unconditional jump to exit the program after printing the result. 
;    This prevents redundant checks or actions after a result has been determined.

; 6. `sys_exit`: Ends the program after handling all cases. 
;    This is called in `label_exit`, ensuring proper termination regardless of the path taken.
