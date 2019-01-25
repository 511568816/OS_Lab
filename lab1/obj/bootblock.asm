
obj/bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    7c00:	fa                   	cli    
    cld                                             # String operations increment
    7c01:	fc                   	cld    

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
    movw %ax, %ds                                   # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
    movw %ax, %ss                                   # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    7c0a:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c0c:	a8 02                	test   $0x2,%al
    jnz seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    7c14:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c16:	a8 02                	test   $0x2,%al
    jnz seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
    7c1c:	e6 60                	out    %al,$0x60

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	6c                   	insb   (%dx),%es:(%edi)
    7c22:	7c 0f                	jl     7c33 <protcseg+0x1>
    movl %cr0, %eax
    7c24:	20 c0                	and    %al,%al
    orl $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
    movl %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg
    7c2d:	ea                   	.byte 0xea
    7c2e:	32 7c 08 00          	xor    0x0(%eax,%ecx,1),%bh

00007c32 <protcseg>:

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    7c32:	66 b8 10 00          	mov    $0x10,%ax
    movw %ax, %ds                                   # -> DS: Data Segment
    7c36:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> ES: Extra Segment
    7c38:	8e c0                	mov    %eax,%es
    movw %ax, %fs                                   # -> FS
    7c3a:	8e e0                	mov    %eax,%fs
    movw %ax, %gs                                   # -> GS
    7c3c:	8e e8                	mov    %eax,%gs
    movw %ax, %ss                                   # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    7c40:	bd 00 00 00 00       	mov    $0x0,%ebp
    movl $start, %esp
    7c45:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    call bootmain
    7c4a:	e8 95 00 00 00       	call   7ce4 <bootmain>

00007c4f <spin>:

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin
    7c4f:	eb fe                	jmp    7c4f <spin>
    7c51:	8d 76 00             	lea    0x0(%esi),%esi

00007c54 <gdt>:
	...
    7c5c:	ff                   	(bad)  
    7c5d:	ff 00                	incl   (%eax)
    7c5f:	00 00                	add    %al,(%eax)
    7c61:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c68:	00                   	.byte 0x0
    7c69:	92                   	xchg   %eax,%edx
    7c6a:	cf                   	iret   
	...

00007c6c <gdtdesc>:
    7c6c:	17                   	pop    %ss
    7c6d:	00 54 7c 00          	add    %dl,0x0(%esp,%edi,2)
	...

00007c72 <readsect>:
        /* do nothing */;
}

/* readsect - read a single sector at @secno into @dst */
static void
readsect(void *dst, uint32_t secno) {
    7c72:	55                   	push   %ebp
    7c73:	89 e5                	mov    %esp,%ebp
    7c75:	57                   	push   %edi
    7c76:	53                   	push   %ebx
    7c77:	89 c7                	mov    %eax,%edi
    7c79:	89 d1                	mov    %edx,%ecx
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    7c7b:	bb f7 01 00 00       	mov    $0x1f7,%ebx
    7c80:	89 da                	mov    %ebx,%edx
    7c82:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7c83:	83 e0 c0             	and    $0xffffffc0,%eax
    7c86:	3c 40                	cmp    $0x40,%al
    7c88:	75 f6                	jne    7c80 <readsect+0xe>
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
    7c8a:	b0 01                	mov    $0x1,%al
    7c8c:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c91:	ee                   	out    %al,(%dx)
    7c92:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7c97:	88 c8                	mov    %cl,%al
    7c99:	ee                   	out    %al,(%dx)
    // wait for disk to be ready
    waitdisk();

    outb(0x1F2, 1);                         // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    7c9a:	89 c8                	mov    %ecx,%eax
    7c9c:	c1 e8 08             	shr    $0x8,%eax
    7c9f:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7ca4:	ee                   	out    %al,(%dx)
    outb(0x1F5, (secno >> 16) & 0xFF);
    7ca5:	89 c8                	mov    %ecx,%eax
    7ca7:	c1 e8 10             	shr    $0x10,%eax
    7caa:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7caf:	ee                   	out    %al,(%dx)
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    7cb0:	89 c8                	mov    %ecx,%eax
    7cb2:	c1 e8 18             	shr    $0x18,%eax
    7cb5:	83 e0 0f             	and    $0xf,%eax
    7cb8:	83 c8 e0             	or     $0xffffffe0,%eax
    7cbb:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7cc0:	ee                   	out    %al,(%dx)
    7cc1:	b0 20                	mov    $0x20,%al
    7cc3:	89 da                	mov    %ebx,%edx
    7cc5:	ee                   	out    %al,(%dx)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    7cc6:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7ccb:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7ccc:	83 e0 c0             	and    $0xffffffc0,%eax
    7ccf:	3c 40                	cmp    $0x40,%al
    7cd1:	75 f8                	jne    7ccb <readsect+0x59>
    asm volatile (
    7cd3:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cd8:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cdd:	fc                   	cld    
    7cde:	f2 6d                	repnz insl (%dx),%es:(%edi)
    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
}
    7ce0:	5b                   	pop    %ebx
    7ce1:	5f                   	pop    %edi
    7ce2:	5d                   	pop    %ebp
    7ce3:	c3                   	ret    

00007ce4 <bootmain>:
    }
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7ce4:	55                   	push   %ebp
    7ce5:	89 e5                	mov    %esp,%ebp
    7ce7:	57                   	push   %edi
    7ce8:	56                   	push   %esi
    7ce9:	53                   	push   %ebx
    7cea:	83 ec 1c             	sub    $0x1c,%esp
    uint32_t secno = (offset / SECTSIZE) + 1;
    7ced:	bb 01 00 00 00       	mov    $0x1,%ebx
        readsect((void *)va, secno);
    7cf2:	89 d8                	mov    %ebx,%eax
    7cf4:	c1 e0 09             	shl    $0x9,%eax
    7cf7:	05 00 fe 00 00       	add    $0xfe00,%eax
    7cfc:	89 da                	mov    %ebx,%edx
    7cfe:	e8 6f ff ff ff       	call   7c72 <readsect>
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7d03:	43                   	inc    %ebx
    7d04:	83 fb 09             	cmp    $0x9,%ebx
    7d07:	75 e9                	jne    7cf2 <bootmain+0xe>
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
    7d09:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d10:	45 4c 46 
    7d13:	75 6a                	jne    7d7f <bootmain+0x9b>
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    7d15:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7d1a:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
    eph = ph + ELFHDR->e_phnum;
    7d20:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
    7d27:	c1 e0 05             	shl    $0x5,%eax
    7d2a:	01 d8                	add    %ebx,%eax
    7d2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (; ph < eph; ph ++) {
    7d2f:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    7d32:	73 3f                	jae    7d73 <bootmain+0x8f>
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d34:	8b 4b 04             	mov    0x4(%ebx),%ecx
    7d37:	8b 73 08             	mov    0x8(%ebx),%esi
    7d3a:	81 e6 ff ff ff 00    	and    $0xffffff,%esi
    uintptr_t end_va = va + count;
    7d40:	8b 43 14             	mov    0x14(%ebx),%eax
    7d43:	01 f0                	add    %esi,%eax
    7d45:	89 45 e0             	mov    %eax,-0x20(%ebp)
    va -= offset % SECTSIZE;
    7d48:	89 c8                	mov    %ecx,%eax
    7d4a:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d4f:	29 c6                	sub    %eax,%esi
    uint32_t secno = (offset / SECTSIZE) + 1;
    7d51:	c1 e9 09             	shr    $0x9,%ecx
    7d54:	8d 79 01             	lea    0x1(%ecx),%edi
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7d57:	39 75 e0             	cmp    %esi,-0x20(%ebp)
    7d5a:	76 12                	jbe    7d6e <bootmain+0x8a>
        readsect((void *)va, secno);
    7d5c:	89 fa                	mov    %edi,%edx
    7d5e:	89 f0                	mov    %esi,%eax
    7d60:	e8 0d ff ff ff       	call   7c72 <readsect>
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7d65:	81 c6 00 02 00 00    	add    $0x200,%esi
    7d6b:	47                   	inc    %edi
    7d6c:	eb e9                	jmp    7d57 <bootmain+0x73>
    for (; ph < eph; ph ++) {
    7d6e:	83 c3 20             	add    $0x20,%ebx
    7d71:	eb bc                	jmp    7d2f <bootmain+0x4b>
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
    7d73:	a1 18 00 01 00       	mov    0x10018,%eax
    7d78:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d7d:	ff d0                	call   *%eax
}

static inline void
outw(uint16_t port, uint16_t data) {
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port));
    7d7f:	ba 00 8a ff ff       	mov    $0xffff8a00,%edx
    7d84:	89 d0                	mov    %edx,%eax
    7d86:	66 ef                	out    %ax,(%dx)
    7d88:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7d8d:	66 ef                	out    %ax,(%dx)
    7d8f:	eb fe                	jmp    7d8f <bootmain+0xab>
