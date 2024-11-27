global _start

section .data
    sensor_value    dd 0                ; Simulated sensor input
    motor_status    db 0                ; Motor status: 0=OFF, 1=ON
    alarm_status    db 0                ; Alarm status: 0=OFF, 1=ON

    HIGH_LEVEL      equ 80              ; High threshold for sensor
    MODERATE_LEVEL  equ 50              ; Moderate threshold for sensor

    prompt          db 'Enter sensor value: ', 0
    input_buffer    db 10 dup(0)        ; Buffer for user input
    motor_msg       db 'Motor Status: ', 0
    alarm_msg       db 'Alarm Status: ', 0
    on_msg          db 'ON', 10, 0      ; "ON" message with newline
    off_msg         db 'OFF', 10, 0     ; "OFF" message with newline

section .text
_start:
    ; Prompt user for sensor value
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, prompt             ; Address of the prompt
    mov     rdx, 20                 ; Length of the prompt string
    syscall

    ; Read user input
    mov     rax, 0                  ; sys_read
    mov     rdi, 0                  ; stdin
    mov     rsi, input_buffer       ; Address of input buffer
    mov     rdx, 10                 ; Maximum input length
    syscall

    ; Convert input to integer
    mov     rsi, input_buffer       ; Address of input buffer
    call    atoi                    ; Result in RAX

    ; Store sensor value
    mov     [sensor_value], eax     ; Store input value

    ; Read sensor value into EAX
    mov     eax, [sensor_value]     

    ; Decision logic based on sensor value
    cmp     eax, HIGH_LEVEL         ; Compare with HIGH_LEVEL
    jg      high_level              ; Jump if greater (High Level)

    cmp     eax, MODERATE_LEVEL     ; Compare with MODERATE_LEVEL
    jg      moderate_level          ; Jump if greater (Moderate Level)

low_level:
    ; Low Level: Motor ON, Alarm OFF
    mov     byte [motor_status], 1
    mov     byte [alarm_status], 0
    jmp     display_status          ; Jump to status display

moderate_level:
    ; Moderate Level: Motor OFF, Alarm OFF
    mov     byte [motor_status], 0
    mov     byte [alarm_status], 0
    jmp     display_status          ; Jump to status display

high_level:
    ; High Level: Motor ON, Alarm ON
    mov     byte [motor_status], 1
    mov     byte [alarm_status], 1

display_status:
    ; Display motor status
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, motor_msg          ; Address of motor message
    mov     rdx, 14                 ; Length of motor message
    syscall

    mov     al, [motor_status]      ; Load motor status
    cmp     al, 1                   ; Compare status
    je      motor_on                ; Jump if ON
    jmp     motor_off               ; Otherwise, OFF

motor_on:
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, on_msg             ; Display "ON"
    mov     rdx, 3
    syscall
    jmp     display_alarm           ; Continue to alarm status

motor_off:
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, off_msg            ; Display "OFF"
    mov     rdx, 4
    syscall

display_alarm:
    ; Display alarm status
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, alarm_msg          ; Address of alarm message
    mov     rdx, 13                 ; Length of alarm message
    syscall

    mov     al, [alarm_status]      ; Load alarm status
    cmp     al, 1                   ; Compare status
    je      alarm_on                ; Jump if ON
    jmp     alarm_off               ; Otherwise, OFF

alarm_on:
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, on_msg             ; Display "ON"
    mov     rdx, 3
    syscall
    jmp     exit_program            ; Exit program

alarm_off:
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, off_msg            ; Display "OFF"
    mov     rdx, 4
    syscall

exit_program:
    ; Exit the program
    mov     rax, 60                 ; sys_exit
    xor     rdi, rdi                ; Exit code 0
    syscall

; Subroutine: ASCII to Integer Conversion (atoi)
; Converts ASCII string to integer
; Input: RSI - Pointer to input buffer
; Output: RAX - Converted integer
atoi:
    xor     rax, rax                ; Clear RAX (result)
    xor     rbx, rbx                ; Clear RBX (base)
    mov     rbx, 10                 ; Base 10 multiplier

atoi_loop:
    movzx   rcx, byte [rsi]         ; Load next character
    cmp     rcx, 10                 ; Check for newline
    je      atoi_done               ; Exit loop if newline
    sub     rcx, '0'                ; Convert ASCII to digit
    imul    rax, rbx                ; Multiply result by base
    add     rax, rcx                ; Add digit to result
    inc     rsi                     ; Move to next character
    jmp     atoi_loop               ; Repeat loop

atoi_done:
    ret                             ; Return to caller

; Documentation
; --------------------------------------------
; This program simulates a control system with sensor input to manage motor and alarm states:
; 1. **Low Level (<= MODERATE_LEVEL)**:
;    - Motor: ON
;    - Alarm: OFF
; 2. **Moderate Level (> MODERATE_LEVEL, <= HIGH_LEVEL)**:
;    - Motor: OFF
;    - Alarm: OFF
; 3. **High Level (> HIGH_LEVEL)**:
;    - Motor: ON
;    - Alarm: ON

; Input is taken as an ASCII string, converted to an integer (`atoi`), and compared to thresholds.
; The motor and alarm states are displayed using appropriate messages (`ON` or `OFF`).
; --------------------------------------------
