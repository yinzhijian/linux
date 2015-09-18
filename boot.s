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
COPYSEG = 0x1000
INITSEG = 0x0000
SETUPLEN = 0x5 #8KB=16*512bytes
_start:
jmpl $BOOTSEG,$go
go:
movw %cs,%ax
movw %ax,%ds
movw %ax,%es
load_setup: #load system into COPYSEG
movw $0,%dx #驱动器0,磁头0;
movw $2,%cx #扇区2,磁道0;
movw $COPYSEG,%ax
movw %ax,%es
xor %bx,%bx #es:bx—>指向数据缓冲区
movw $0x0200+SETUPLEN,%ax #!置为服务二，读入SETUPLEN个扇区;
int $0x13 #中断13;
jnc ok_load

die: jmp die
ok_load:
#coty copyseg to initseg
#cli
xor %si,%si
xor %di,%di
movw $COPYSEG,%ax
movw %ax,%ds
movw $INITSEG,%ax
movw %ax,%es
movw $512*(SETUPLEN),%cx
cld
rep movsb
movw $BOOTSEG,%ax
movw %ax,%ds
#sti
nop
nop
nop
lidt idt_48
lgdt gdt_48
# 打开地址线A20
inb     $0x92,%al
orb     $0b00000010,%al
outb    %al, $0x92
#movl %cr0,%ebx
#or $1,%ebx
#movl %ebx,%cr0 #set pe =1
movw $1,%ax
lmsw %ax
#66ea000000000800    jmp far 0008:00000000
#.byte 0x66, 0xea            # prefix + jmpi-opcode
#.long    0
#.word   8  #.word   $SelectorCode32,不合法
jmpl $8,$0
.align 8
gdt:
.word 0,0,0,0 #gdt0
.word 0x007f,0x0000,0x9a00,0x00c0 #gdt1 code 
.word 0x007f,0x0000,0x9200,0x00c0 #gdt2 data
.word 0x0002,0x8000,0x920b,0x00c0 #gdt3 display
.word 0x0001,0xffff,0x9600,0x00c0 #gdt4 stack

gdt_end:
idt_48:
.word 0 #idt length=0
.word 0,0 #base addr=0
gdt_48:
.word 0x1f #24 bytes contains 3 gdt
.word 0x7c00+gdt,0
.org 510
.word 0xAA55
.text
endtext:
.data
enddata:
