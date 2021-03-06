[BITS 16]

; ORG 7E00h

trampo:
    mov ax, 0x2401 ; A20
    int 0x15

    cli

    lgdt [gdt_ptr] ; GDT

    mov eax, cr0 ; prot mode bit
    or eax, 1
    mov cr0, eax

    jmp 8:OOOOOOH_YEAH_IM_FEELING_MYSELF_SO_PROTECTED_NOW

trampo.catch_loop:
    hlt
    jmp trampo.catch_loop


[BITS 32]
OOOOOOH_YEAH_IM_FEELING_MYSELF_SO_PROTECTED_NOW:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x1fe0000

    extern kmain
    call kmain

    jmp trampo.catch_loop
    


; TODO: edit GDT for this range
; 0xf0000 - 0x7fe0000
; 0x7ef0000 size
gdt_start:
gdt_null:
    dq 0
gdt_code:
    dw 0xFFFF           ; Limit 0:15
    dw 0x0000           ; Base 0:15
    db 0x00             ; Base 16:23
    db 10011010b        ; Access Byte
    db 11001111b        ; Flags, Limit 16:19
    db 0x00             ; Base 24:31
gdt_data:
    dw 0xFFFF           ; Limit 0:15
    dw 0x0000           ; Base 0:15
    db 0x00             ; Base 16:23
    db 10010010b        ; Access Byte
    db 11001111b        ; Flags, Limit 16:19
    db 0x00             ; Base 24:31
gdt_end:
gdt_ptr:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
; STACK_SEG equ gdt_stack - gdt_start

times 512 - ($ - $$) db 90h