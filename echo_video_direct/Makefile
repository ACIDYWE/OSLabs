
CC=nasm
CFLAGS=-fbin
LSTFLAGS=-e
BIN=bootloader.bin
SRC=bootloader.asm
IMG=disk.img

all: $(BIN) $(IMG)
	dd if=$< of=$(word 2,$^) bs=1 count=512 conv=notrunc

$(BIN): $(SRC)
	# Get all the sources and just put it in a god damn nasm compiler
	$(CC) $(COMPILE_FLAGS) -o $@ $^


$(IMG):
	dd if=/dev/zero of=$@ bs=1m count=1


list: $(SRC)
	$(CC) $(LSTFLAGS) $^


clean:
	rm -f $(IMG) $(BIN)