BITS 16

ORG 0x7c00


start:
    cli
    xor ax, ax
    mov ds, ax

    mov ss, ax
    mov sp, 0FFFEh

    jmp 0:echo

halt_loop:
    hlt
    jmp $


echo:

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


    mov ah, 0xE
    mov si, too_lazy
    .echo_loop:
        lodsb
        test al, al
        jz .end_of_echo_loop
        int 10h
        jmp .echo_loop

    .end_of_echo_loop:


    jmp halt_loop


too_lazy db 'I', 0x27,'m too lazy now, so it no ascii arts left, sorry ;C', 0

times 510 - ($ - $$) db 90h
dw 0xAA55