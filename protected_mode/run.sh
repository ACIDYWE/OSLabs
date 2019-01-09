#!/bin/bash

if [ "$#" -ne 0 ]; then
    # DEBUG
    qemu-system-i386 -s -S -monitor stdio -drive file=disk.img,format=raw -m 32
else
    # NON DEBUG
    qemu-system-i386 -monitor stdio -drive file=disk.img,format=raw -m 32
fi
