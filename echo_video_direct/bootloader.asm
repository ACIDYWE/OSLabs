BITS 16

ORG 0x7c00
video_memory equ 0B800h


start:
	
	xor ax, ax
	mov ds, ax

	mov ss, ax
	mov sp, FFFEh


	mov si, aGreetings
	call echo

	jmp $


echo:
	pusha

	mov ax, video_memory
	mov es, ax

	mov cx, 1000h
	xor di, di
	.clear_screen:
		mov [es:di], word 0E20h
		add edi, 2
		loop .clear_screen

	mov cx, aGreetings.len
	xor di, di
	.loopy_loop:
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