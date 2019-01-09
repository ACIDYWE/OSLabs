%ifndef SECTORS_TO_READ
    %define SECTORS_TO_READ 1
%endif

%define MEM_AREA            07E00h
%define SECTORS_AMOUNT      62

%macro verify 3
    %if %1 <= %2
        ; nothing
    %else
        %error %3
    %endif
%endmacro

BITS 16

ORG 7c00h

; FUCKING DONE!
; MAXIM DON'T FUCKING TOUCH IT, I DARE YOU, I GOD DAMN DARE YOU

start:

    xor ax, ax
    mov ds, ax

    mov [DRIVE], dx

    mov ss, ax
    mov sp, 07C00h

    mov es, ax

    jmp 0:read_kernel

halt_loop:
    hlt
    jmp halt_loop

read_kernel:
    verify SECTORS_TO_READ, SECTORS_AMOUNT, "[!] INVALID SECTORS_TO_READ, TOO BIG"
    

    mov bx, MEM_AREA
    
    mov ah, 2                   ;   read sectors into memory (int 0x13, ah = 0x02)
    mov al, byte SECTORS_TO_READ     
    
    mov dx, [DRIVE]             ;   dl - drive index
    xor dh, dh                  ;   dh - head
    
    xor cx, cx
    mov cl, 2

    int 13h

    jmp MEM_AREA

    jmp halt_loop


DRIVE dw 0
aTooBig db 'Total amount of SECTORS to read is too big', 0
aFail db 'Something wrong', 0
aSuccess db 'It', 27, 's totally ok', 0
times 510 - ($ - $$) db 90h
dw 0xAA55
