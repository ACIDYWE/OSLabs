BITS 16

ORG 0x7c00
video_memory equ 0B800h


start:
    
    xor ax, ax
    mov ds, ax

    mov ss, ax
    mov sp, 07C00h

    jmp 0:echo
halt_loop:
    hlt
    jmp $


echo:
    pusha

    mov ax, video_memory
    mov es, ax

    mov cx, 01000h
    xor di, di
    .clear_screen:
        mov [es:di], word 4020h
        add edi, 2
        loop .clear_screen

    mov cx, ascii_art.len
    shr cx, 1

    mov si, ascii_art
    xor di, di
    .loopy_loop:
        mov ax, [si]
        
        push cx
        mov cx, 16
        .nested_loop:
            test ax, 08000h
            jz .red_space
            mov [es:di], byte ' '
            inc di
            mov [es:di], byte 20h
            jmp .kek
            .red_space:
                inc di
                mov [es:di], byte 40h
            .kek:
            shl ax, 1
            inc di
            loop .nested_loop
        pop cx

        pusha

        ; little sleepy tho
        mov al, 0
        mov ah, 86h
        mov cx, 1
        mov dx, 2
        int 15h

        popa

        add si, 2
        loop .loopy_loop

    popa

    jmp halt_loop


ascii_art dw 0, 1, 65535, 49152, 0, 0, 15, 49153, 64512, 0, 0, 120, 0, 3840, 0, 0, 224, 0, 192, 0, 0, 1728, 0, 432, 0, 0, 1632, 0, 432, 0, 0, 1632, 0, 816, 0, 0, 867, 64543, 58208, 0, 1, 49255, 63503, 63873, 57344, 3, 57543, 61895, 61827, 61440, 6, 12481, 50145, 49542, 12288, 14, 7776, 2032, 828, 14336, 31, 61567, 34800, 65283, 64512, 7, 48647, 49152, 60447, 47104, 0, 2023, 12289, 40188, 0, 0, 126, 57341, 48896, 0, 0, 6, 54613, 22528, 0, 0, 502, 16382, 14272, 0, 1, 65411, 0, 24703, 49152, 3, 31, 49153, 65024, 24576, 1, 49648, 32767, 1985, 49152, 0, 25472, 4088, 227, 0, 0, 26112, 0, 51, 0, 0, 7680, 0, 15, 0
.len equ $ - ascii_art

times 510 - ($ - $$) db 90h
dw 0xAA55
