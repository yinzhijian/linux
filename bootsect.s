.code16
.global _start, begtext, begdata, begbss, endtext, enddata, endbss
.text
begtext:
.data
begdata:
.bss
begbss:
.text
BOOTSEG = 0x07c0
_start:
jmpl $BOOTSEG,$go
go:
movw %cs,%ax
movw %ax,%ds
movw %ax,%es
movl %cr0,%ebx
or $1,%ebx
movl %ebx,%cr0
sgdt gdt48
movw $msg1,%bx
movb %ah,17(%bx)
movw $20,%cx
movw $0x1004,%dx
movw $0x000c,%bx
movw $msg1,%bp
movw $0x1301,%ax
int $0x10
loop1: jmp loop1
msg1:
.ascii "Loading system ..."
.byte 13,10
gdt48:
.byte 0,0,0,0,0xff,0xff
end:
.org 510
.word 0xAA55
.text
endtext:
.data
enddata:
.bss
endbss:
