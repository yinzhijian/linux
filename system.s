.global startup_32
.text
VIDEOSEG = 0xb800
startup_32:
#sti
movl $0x10,%eax
movw %ax,%ds
lidt idt_48
lgdt gdt_48
movl $0x10,%eax
movw %ax,%ds
movw %ax,%es
movw %ax,%fs
movw %ax,%gs
movl $kernel_stack,%esp
pushl $task0
pushw $0
pushw $0x08
movl -4(%esp),%eax
or 0x00002000,%eax
movl %eax,-4(%esp)
popf
pushl $kernel_stack
pushw $0x10
pushw $0x0
iret
task0:
#movw $VIDEOSEG,%ax
movl $0x18,%eax
movw %ax,%es
xor %si,%si
movw $msg1,%bx
loop2:
movb (%bx),%al
movb %al,%es:(%si)
add $2,%si
inc %bx
sub $0,%al
jnz loop2
push %eax
push %ebx
end:jmp end
.fill 256,4
kernel_stack:
.fill 256,4
task0_stack: 
tss0:
.long 0,0,0,0 #
.long 0,0,0,0
.long 0,0,0,0
.long 0,0,0,0
.long 0,0,0,0
.long 0,0,0,0
.long 0,0
tss0_end:
gdt:
.word 0,0,0,0 #gdt0
.word 0x007f,0x0000,0x9a00,0x00c0 #gdt1 code 
.word 0x007f,0x0000,0x9200,0x00c0 #gdt2 data
.word 0x0002,0x8000,0x920b,0x00c0 #gdt3 display
.word tss0_end-tss0,tss0,0xe900,0x00c0 #gdt4 tss0
gdt_end:
gdt_48:
.word 0x27
.word gdt,0
idt_48:
.word 0
.word 0,0
msg1:
.ascii "Loading system ..."
.byte 13,10,0
