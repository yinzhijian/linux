#!/bin/sh
as boot.s -o boot.o --32
ld boot.o -o boot -Ttext=0x00 -m elf_i386 --oformat binary
as system.s -o system.o --32
ld system.o -o system -Ttext=0x00 -m elf_i386 --oformat binary
dd if=boot of=boot.img 
dd if=system of=boot.img seek=1
cp boot.img bochs-2.6.1/

