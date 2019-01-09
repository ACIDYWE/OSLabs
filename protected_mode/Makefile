CC=nasm
CFLAGS=-fbin
LSTFLAGS=-e
SECNUM=1
SECTORS=-dSECTORS_TO_READ=$(SECNUM)
BOOTLOADER_BIN=bootloader.bin
BOOTLOADER_SRC=bootloader.asm
IMG=disk.img
PROTMODE_SRC=prot_mode_trampoline.asm
PROTMODE_OBJ=prot_mode_trampoline.o
KERNEL_SRC=kernel.c
KERNEL_OBJ=kernel.o
KERNEL_BIN=kernel
UTILS_SRC=utils.c
UTILS_OBJ=utils.o
GCC=gcc
GCC_FLAGS=-m32 -fno-pie -nostdlib -nodefaultlibs -nostartfiles -fno-builtin -Wno-int-to-pointer-cast -march=i386 -c
LINKER=ld
LINKER_FLAGS=-T ldscript.ld -o


# building order:
# 	1 - kernel (to set some flags for building the bootloader)
# 	2 - bootloader
# 	3 - final disk.img
all: $(KERNEL_BIN) $(BOOTLOADER_BIN) $(IMG) 
	dd if=$(BOOTLOADER_BIN) of=$(IMG) bs=1 count=512 conv=notrunc
	dd if=$(KERNEL_BIN) of=$(IMG) bs=512 count=$(SECNUM) seek=1 conv=notrunc


$(KERNEL_BIN): $(PROTMODE_OBJ) $(KERNEL_OBJ) $(UTILS_OBJ)
	$(LINKER) $(LINKER_FLAGS) $@ $^

	$(eval SECNUM := $(shell wc -c kernel.o | awk '{ print int($$1 / 512) + (($$1 % 512) != 0) + 1}'))
	SECTORS=-dSECTORS_TO_READ=$(SECNUM)

$(UTILS_OBJ): $(UTILS_SRC)
	$(GCC) $(GCC_FLAGS) $(UTILS_SRC)

$(KERNEL_OBJ): $(KERNEL_SRC)
	$(GCC) $(GCC_FLAGS) $(KERNEL_SRC)


$(PROTMODE_OBJ): $(PROTMODE_SRC)
	$(CC) -felf32 -o $@ $^
	

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(CC) $(CFLAGS) $(SECTORS) -o $@ $^


$(IMG):
	dd if=/dev/zero of=$@ bs=1M count=1


list_bootloader: $(BOOTLOADER_SRC)
	$(CC) $(LSTFLAGS) $(SECTORS) $^


list_protmode: $(PROTMODE_SRC)
	$(CC) $(LSTFLAGS) $^


clean:
	rm -f $(IMG) $(BIN) $(DRIVE_DATA) $(KERNEL_OBJ) $(KERNEL_BIN) $(PROTMODE_OBJ) $(BOOTLOADER_BIN) $(UTILS_OBJ)


print-%: ; @echo $* = $($*)