section .data
    msg_prompt db "Enter a single digit (0-9): ", 0    ; Prompt message
    msg_prompt_len equ $ - msg_prompt                 ; Length of the prompt
    msg_invalid db "Invalid input! Please enter a digit (0-9).", 0 ; Error message
    msg_invalid_len equ $ - msg_invalid              ; Length of the error message
    newline_char db 10                                ; Newline character

section .bss
    digits_buffer resb 5    ; Buffer to store 5 digits
    input_buffer resb 2     ; Buffer for input (character + newline)

section .text
    global _start

_start:
    ; Initialize counter for storing digits
    xor rbx, rbx    ; Use rbx as index for digits_buffer

read_input:
    ; Display the input prompt
    mov rax, 1              ; sys_write
    mov rdi, 1              ; File descriptor: stdout
    mov rsi, msg_prompt     ; Address of the prompt
    mov rdx, msg_prompt_len ; Length of the prompt
    syscall

    ; Read a character
    mov rax, 0              ; sys_read
    mov rdi, 0              ; File descriptor: stdin
    mov rsi, input_buffer   ; Address of the input buffer
    mov rdx, 2              ; Read 2 bytes
    syscall

    ; Validate the input
    mov al, [input_buffer]  ; Load the first byte of input
    cmp al, '0'             ; Check if less than '0'
    jl handle_invalid       ; If true, go to error handling
    cmp al, '9'             ; Check if greater than '9'
    jg handle_invalid       ; If true, go to error handling

    ; Store valid input in digits_buffer
    mov [digits_buffer + rbx], al ; Save digit in buffer
    inc rbx                       ; Increment index

    ; Check if all digits are entered
    cmp rbx, 5
    jl read_input          ; If not, repeat input process

    ; Reverse the buffer
    xor rbx, rbx            ; Reset rbx for the left index
    mov rcx, 4              ; Set rcx as the right index

reverse_digits:
    ; Check if reversal is complete
    cmp rbx, rcx
    jge display_output      ; Exit if indices have crossed

    ; Swap digits at rbx and rcx
    mov al, [digits_buffer + rbx]
    mov bl, [digits_buffer + rcx]
    mov [digits_buffer + rbx], bl
    mov [digits_buffer + rcx], al

    ; Adjust indices
    inc rbx
    dec rcx
    jmp reverse_digits      ; Repeat for next pair

display_output:
    ; Print reversed digits
    xor rbx, rbx            ; Reset index to start printing

print_loop:
    mov al, [digits_buffer + rbx] ; Load digit
    mov [input_buffer], al        ; Move it to input_buffer

    ; Print digit
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, input_buffer   ; Address of input_buffer
    mov rdx, 1              ; Print 1 byte
    syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline_char
    mov rdx, 1
    syscall

    ; Check if all digits are printed
    inc rbx
    cmp rbx, 5
    jl print_loop           ; Continue if more digits remain

exit_program:
    mov rax, 60             ; sys_exit
    xor rdi, rdi            ; Exit status 0
    syscall

handle_invalid:
    ; Display error message
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, msg_invalid    ; Address of error message
    mov rdx, msg_invalid_len ; Length of error message
    syscall

    ; Restart input process
    jmp read_input

;Documentation
;This program prompts the user to input five single-digit integers (0-9), validates the inputs, stores them in a buffer, 
;reverses the buffer in place, and displays the reversed sequence.
;
;Key Features
;Input Validation:
;Ensures only valid digits ('0'–'9') are accepted.
;Displays an error message for invalid inputs and retries input collection.
;
;In-Place Reversal:
;Reverses the sequence using two pointers (rbx for the left index and rcx for the right index).
;Avoids additional memory allocation.
;
;Output Display:
;Prints the reversed digits, one per line.