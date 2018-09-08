BITS 16

ORG 0x7c00
video_memory equ 0A000h

start:
	
	xor ax, ax
	mov ds, ax

	mov ax, 7c0h
	mov es, ax
	xor sp, sp


	mov si, aGreetings
	call echo

	jmp $


echo:
	pusha

	mov ax, video_memory
	mov es, ax

	.loopy_loop:
		mov cx, aGreetings.len
		xor di, di
		mov bl, [si]
		mov [es:di], bl
		inc si
		inc di
		loop .loopy_loop

	popa

	ret


aGreetings db 'Sosi huy!'
.len equ $ - aGreetings

times 510 - ($ - $$) db 90h
dw 0xAA55