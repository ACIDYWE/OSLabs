UNAME := $(shell uname)

ifeq ($(UNAME),Darwin)
	TYPE=macho64
	EXT=m
else
	TYPE=elf32
	EXT=M
endif


CC=nasm
CFLAGS=-fbin
LSTFLAGS=-e
SECNUM=1
SECTIONS=-dSECTIONS_TO_READ=$(SECNUM)
BOOTLOADERBIN=bootloader.bin
BOOTLOADERSRC=bootloader.asm
IMG=disk.img
PROTMODE_SRC=prot_mode_trampoline.asm
PROTMODE_BIN=prot_mode_trampoline
KERNEL_SRC=kernel.c
KERNEL_BIN=kernel

all: kek print-TEMP
	echo 'huy'

run: build
	./run.sh

debug: build
	./run.sh debug

# TODO: rearrange dependencies to make order of building correct
# building order should be:
# 	1 - kernel (to set some flags for building the bootloader)
# 	2 - bootloader
# 	3 - final disk.img
build: $(BOOTLOADER_BIN) $(IMG) $(KERNEL_BIN)
	dd if=$< of=$(word 2,$^) bs=1 count=512 conv=notrunc
	# dd if=$(word 3,$^) bs=512 count=$(SECNUM) >> $(word 2, $^)
	# dd if=$(word 3, $^) of=$(word 2, $^) bs=1 count=512 conv=notrunc seek=512

$(KERNEL_BIN): kernel.c
	# $(KERNEL_SRC) $(PROTMODE_BIN)

	$(eval SECNUM := $(shell wc -c kernel | awk '{ print int($$1 / 512) + (($$1 % 512) != 0) }'))
	SECTIONS=-dSECTIONS_TO_READ=$(SECNUM)

$(PROTMODE_BIN): $(PROTMODE_SRC)
	$(CC) $(CFLAGS) -o $@ $^
	

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(CC) $(CFLAGS) $(SECTIONS) -o $@ $^


$(IMG):
	dd if=/dev/zero of=$@ bs=1 count=512


list_bootloader: $(BOOTLOADER_SRC)
	$(CC) $(LSTFLAGS) $(SECTIONS) $^

list_protmode: $(PROTMODE_SRC)
	$(CC) $(LSTFLAGS) $^

clean:
	rm -f $(IMG) $(BIN) $(DRIVE_DATA)

print-%: ; @echo $* = $($*)