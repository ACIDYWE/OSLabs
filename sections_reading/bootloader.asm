%ifndef SECTIONS_TO_READ
    %define SECTIONS_TO_READ 1
%endif

%define MEM_AREA 07E00h

BITS 16

ORG 0x7c00

start:

    xor ax, ax
    mov ds, ax

    mov [DRIVE], dx

    mov ss, ax
    mov sp, 07C00h

    mov es, ax

    jmp 0:read

halt_loop:
    hlt
    jmp halt_loop

read:
    
    mov ah, 2
    mov al, SECTIONS_TO_READ
    
    mov dx, [DRIVE]
    xor dh, dh
    
    xor cx, cx
    mov cl, 2

    mov bx, MEM_AREA

    int 13h


    mov ah, 2
    xor bh, bh
    xor dh, dh
    xor dl, dl
    int 10h

    mov cx, 0x1000
    mov ah, 0xE
    mov al, 32
    .clear_loop:
        int 10h
        loop .clear_loop

    mov ah, 2
    xor bh, bh
    xor dh, dh
    xor dl, dl
    int 10h


    mov bx, MEM_AREA
    mov ah, 0xE
    .echo_loop:
        mov al, [es:bx]
        inc bx
        test al, al
        jz .end_of_echo_loop
        int 10h
        jmp .echo_loop

    .end_of_echo_loop:


    jmp halt_loop


DRIVE dw 0
times 510 - ($ - $$) db 90h
dw 0xAA55
