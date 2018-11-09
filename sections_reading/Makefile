UNAME := $(shell uname)

ifeq ($(UNAME),Darwin)
	TYPE=macho64
	EXT=m
else
	TYPE=elf32
	EXT=M
endif

CC=nasm
CFLAGS=-fbin -dSECTIONS_TO_READ=1
LSTFLAGS=-e -dSECTIONS_TO_READ=1
BIN=bootloader.bin
SRC=bootloader.asm
IMG=disk.img
DRIVE_DATA=rude_file.txt


all: $(BIN) $(IMG) $(DRIVE_DATA)
	dd if=$< of=$(word 2,$^) bs=1 count=512 conv=notrunc
	dd if=$(word 3, $^) of=$(word 2, $^) bs=1 count=512 conv=notrunc seek=512

$(DRIVE_DATA):
	echo 'kurwa perdole sooqa nahuy pizdec blyat' > $@

$(BIN): $(SRC)
	# Get all the sources and just put it in a god damn nasm compiler
	$(CC) $(CFLAGS) -o $@ $^


$(IMG):
	dd if=/dev/zero of=$@ bs=1$(EXT) count=1


list: $(SRC)
	$(CC) $(LSTFLAGS) $^


clean:
	rm -f $(IMG) $(BIN) $(DRIVE_DATA)