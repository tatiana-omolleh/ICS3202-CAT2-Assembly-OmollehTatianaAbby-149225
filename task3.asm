section .data
    prompt_msg      db 'Enter a number (0-12): ', 0  ; Prompt to input a number
    output_msg      db 'Factorial is: ', 0           ; Output message
    newline_char    db 10, 0                         ; Newline character
    input_buf       db 10 dup(0)                     ; Buffer for user input
    result_buf      db 20 dup(0)                     ; Buffer for factorial result

section .bss
    ; No uninitialized variables used

section .text
global _start

_start:
    ; Display input prompt
    mov     rax, 1                  ; syscall: write
    mov     rdi, 1                  ; File descriptor: stdout
    mov     rsi, prompt_msg         ; Address of prompt message
    mov     rdx, 22                 ; Length of prompt message
    syscall

    ; Read input into input_buf
    mov     rax, 0                  ; syscall: read
    mov     rdi, 0                  ; File descriptor: stdin
    mov     rsi, input_buf          ; Address of input buffer
    mov     rdx, 10                 ; Max input length
    syscall

    ; Convert input to integer
    mov     rsi, input_buf          ; Address of input buffer
    call    str_to_int              ; Result stored in RAX

    ; Validate input: check if 0 <= input <= 12
    cmp     rax, 12
    ja      invalid_entry
    cmp     rax, 0
    jl      invalid_entry

    ; Calculate factorial
    push    rax                     ; Save input number on stack
    call    calc_factorial          ; Result stored in RAX
    add     rsp, 8                  ; Clean up stack

    ; Convert factorial result to ASCII string
    mov     rsi, result_buf         ; Address of result buffer
    call    int_to_str

    ; Display output message
    mov     rax, 1                  ; syscall: write
    mov     rdi, 1                  ; stdout
    mov     rsi, output_msg         ; Address of output message
    mov     rdx, 14                 ; Length of output message
    syscall

    ; Display the factorial result
    mov     rax, 1                  ; syscall: write
    mov     rdi, 1                  ; stdout
    mov     rsi, result_buf         ; Address of result buffer
    mov     rdx, 20                 ; Max result length
    syscall

    ; Print a newline character
    mov     rax, 1                  ; syscall: write
    mov     rdi, 1                  ; stdout
    mov     rsi, newline_char       ; Address of newline
    mov     rdx, 1                  ; Length of newline
    syscall

    ; Exit program
    mov     rax, 60                 ; syscall: exit
    xor     rdi, rdi                ; Exit code 0
    syscall

invalid_entry:
    ; Handle invalid input
    mov     rax, 1                  ; syscall: write
    mov     rdi, 1                  ; stdout
    mov     rsi, newline_char       ; Print a newline
    mov     rdx, 22                 ; Error message length
    syscall

    ; Exit program
    mov     rax, 60                 ; syscall: exit
    xor     rdi, rdi                ; Exit code 0
    syscall

; Subroutine: Factorial Calculation
calc_factorial:
    mov     rbx, 1                  ; Initialize result in RBX
    cmp     rax, 0                  ; Check for input 0
    je      factorial_done          ; If 0, factorial = 1
factorial_loop:
    imul    rbx, rax                ; Multiply result by current RAX
    dec     rax                     ; Decrement RAX
    jnz     factorial_loop          ; Continue loop if RAX != 0
factorial_done:
    mov     rax, rbx                ; Move result to RAX
    ret

; Subroutine: ASCII to Integer Conversion
str_to_int:
    xor     rax, rax                ; Clear RAX
    xor     rcx, rcx                ; Clear RCX (multiplier)
    mov     rcx, 10                 ; Set base to 10

conversion_loop:
    movzx   rdx, byte [rsi]         ; Load next character
    cmp     rdx, 10                 ; Check for newline
    je      conversion_done
    sub     rdx, '0'                ; Convert ASCII to digit
    imul    rax, rcx                ; Multiply result by 10
    add     rax, rdx                ; Add digit to result
    inc     rsi                     ; Move to next character
    jmp     conversion_loop

conversion_done:
    ret

; Subroutine: Integer to ASCII Conversion
int_to_str:
    xor     rcx, rcx                ; Reset digit counter
itoa_loop:
    xor     rdx, rdx                ; Clear RDX for division
    mov     rbx, 10                 ; Set base to 10
    div     rbx                     ; Divide RAX by 10
    add     dl, '0'                 ; Convert remainder to ASCII
    push    rdx                     ; Push ASCII character onto stack
    inc     rcx                     ; Increment digit counter
    test    rax, rax                ; Check if RAX == 0
    jnz     itoa_loop

write_chars:
    pop     rdx                     ; Get digit from stack
    mov     [rsi], dl               ; Write digit to buffer
    inc     rsi                     ; Advance buffer pointer
    loop    write_chars

    mov     byte [rsi], 0           ; Null-terminate string
    ret

;Documentation
;This program calculates the factorial of an integer (0–12) provided by the user, validates the input, computes the result iteratively, and displays the output as an ASCII string.

;Key Features
;Input Validation:
;Ensures the user input is a valid number between 0 and 12.
;Exits gracefully with invalid inputs.

;Factorial Calculation:
;Performed iteratively in calc_factorial.
;Edge case 0! = 1 is explicitly handled.

;Subroutines:
;str_to_int: Converts ASCII string input to integer.
;int_to_str: Converts integer result to ASCII for output.

;Stack Management:
;Stack is used to preserve digits during conversion.

;Registers:
;RAX: Input, intermediate, and result holder.
;RBX: Accumulates the factorial result.
;RSI: Points to input/output buffers.

;Error Handling:
;Invalid input triggers a newline output and program exit.