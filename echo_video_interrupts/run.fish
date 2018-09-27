#!/usr/local/bin/fish

if count $argv >/dev/null
    # DEBUG
    qemu-system-i386 -s -S -monitor stdio -drive file=disk.img,format=raw -m 32
else
    # NON DEBUG
    qemu-system-i386 -monitor stdio -drive file=disk.img,format=raw -m 32
end