# Lab1 report

## [练习1]

### [练习1.1] 
操作系统镜像文件 ucore.img 是如何一步一步生成的?(需要比较详细地解释 Makefile 中每一条相关命令和命令参数的含义,以及说明命令导致的结果)

答：

ucore.img 的内容由 bootblock 和 kernel 组成。

#### kernel 的生成

编译以下文件，生成*.o
```
    kern/init/init.c
    kern/libs/readline.c
    kern/libs/stdio.c
    kern/debug/kdebug.c
    kern/debug/kmonitor.c
    kern/debug/panic.c
    kern/driver/clock.c
    kern/driver/console.c
    kern/driver/intr.c
    kern/driver/picirq.c
    kern/trap/trap.c
    kern/trap/trapentry.S
    kern/trap/vectors.S
    kern/mm/pmm.c
    libs/printfmt.c
    libs/string.c
```

Makefile代码
```
$(call add_files_cc,$(call listf_cc,$(KSRCDIR)),kernel,$(KCFLAGS))
```

实际执行代码
```
i386-elf-gcc -Ikern/init/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/init/init.c -o obj/kern/init/init.o
i386-elf-gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/readline.c -o obj/kern/libs/readline.o
i386-elf-gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/stdio.c -o obj/kern/libs/stdio.o
i386-elf-gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/kdebug.c -o obj/kern/debug/kdebug.o
i386-elf-gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/kmonitor.c -o obj/kern/debug/kmonitor.o
i386-elf-gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/panic.c -o obj/kern/debug/panic.o
i386-elf-gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/clock.c -o obj/kern/driver/clock.o
i386-elf-gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/console.c -o obj/kern/driver/console.o
i386-elf-gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/intr.c -o obj/kern/driver/intr.o
i386-elf-gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/picirq.c -o obj/kern/driver/picirq.o
i386-elf-gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/trap.c -o obj/kern/trap/trap.o
i386-elf-gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/trapentry.S -o obj/kern/trap/trapentry.o
i386-elf-gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/vectors.S -o obj/kern/trap/vectors.o
i386-elf-gcc -Ikern/mm/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/mm/pmm.c -o obj/kern/mm/pmm.o
i386-elf-gcc -Ilibs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/  -c libs/printfmt.c -o obj/libs/printfmt.o
i386-elf-gcc -Ilibs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/  -c libs/string.c -o obj/libs/string.o
```

将上述文件生成的*.o文件链接生成 bin/kernel：

Makefile代码
```
$(kernel): tools/kernel.ld
$(kernel): $(KOBJS)
@echo + ld $@
$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
@$(OBJDUMP) -S $@ > $(call asmfile,kernel)
@$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)
```

实际执行代码
```
i386-elf-ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/readline.o obj/kern/libs/stdio.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/debug/panic.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/intr.o obj/kern/driver/picirq.o obj/kern/trap/trap.o obj/kern/trap/trapentry.o obj/kern/trap/vectors.o obj/kern/mm/pmm.o  obj/libs/printfmt.o obj/libs/string.o
```

#### bootblock的生成

编译 boot/bootasm.S、boot/bootmain.c，生成 boot/bootasm.o、boot/bootmain.o：

Makefile 代码
```
bootfiles = $(call listf_cc,boot)
$(foreach f,$(bootfiles),$(call cc_compile,$(f),$(CC),$(CFLAGS) -Os -nostdinc))
```

实际执行代码
```
i386-elf-gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootasm.S -o obj/boot/bootasm.o
i386-elf-gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootmain.c -o obj/boot/bootmain.o
```

将生成的 boot/bootasm.o、boot/bootmain.o 链接生成 bin/bootblock.out：

Makefile 代码
```
$(bootblock): $(call toobj,$(bootfiles)) | $(call totarget,sign)
@echo + ld $@
$(V)$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 $^ -o $(call toobj,bootblock)
@$(OBJDUMP) -S $(call objfile,bootblock) > $(call asmfile,bootblock)
# 拷贝以二进制格式拷贝bootblock.o到bootblock.out
@$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)
```

实际执行代码
```
i386-elf-ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
```
将 tools/sign.c 编译链接为可执行文件：

Makefile 代码
```
$(call add_files_host,tools/sign.c,sign,sign)
$(call create_target_host,sign,sign)
```

实际执行代码
```
gcc -Itools/ -g -Wall -O2 -c tools/sign.c -o obj/sign/tools/sign.o
gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign
```

检察 obj/bootblock.out 的大小，生成 bin/bootblock：

Makefile 代码
```
@$(call totarget,sign) $(call outfile,bootblock) $(bootblock)
```

执行输出
```
'obj/bootblock.out' size: 500 bytes
build 512 bytes boot sector: 'bin/bootblock' success!
```

#### ucore.img 的生成

Makefile 代码
```
UCOREIMG    := $(call totarget,ucore.img)

$(UCOREIMG): $(kernel) $(bootblock)
$(V)dd if=/dev/zero of=$@ count=10000
$(V)dd if=$(bootblock) of=$@ conv=notrunc
$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc
```

实际执行代码
```
// 生成10000个512字节的块，块的内容为0。
dd if=/dev/zero of=bin/ucore.img count=10000 
// 将bootblock复制到ucore.img的第0块。
dd if=bin/bootblock of=bin/ucore.img conv=notrunc
// 从第1块开始拷贝kernel。
dd if=bin/kernel of=bin/ucore.img seek=1 conv=notrunc
```

>所有命令参数的含义
```
-ggdb  生成可供gdb使用的调试信息
-m32 生成32位机器的汇编代码
-gstabs  以stabs格式生成的调试信息
-nostdinc  不在标准系统目录中找头文件
-fno-stack-protector  禁用堆栈保护
-Os  优化减小代码大小
-I 选择头文件所在目录
-fno-builtin  除非包含__builtin_前缀，否则不进行builtin函数的优化
-m elf_i386  模拟为i386上的连接器
-nostdlib  不连接系统标准启动文件和标准库文件,只把指定的文件传递给连接器
-N  将代码段和数据段设置为可读写
-e  设置程序的入口函数
-Ttext  制定代码段开始位置
-S  移除所有符号和重定位信息
-O  指定输出文件格式
-T  使用指定脚本进行链接
```

[练习1.2] 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么?

答：

大小为512字节，最后一个字节的为0xAA，倒数第二个字节为0x55。


## [练习2]

### [练习2.1] 从 CPU 加电后执行的第一条指令开始,单步跟踪 BIOS 的执行。

答：

修改gdbinit内容为
```
file bin/kernel
set architecture i8086
target remote :1234
```

在lab1目录下执行make debug，在gdb的调试界面输入
```
si
```

即可单步跟踪。

使用
```
x /10i $pc
```

可以显示当前eip处的十条汇编指令。

### [练习2.2] 在初始化位置 0x7c00 设置实地址断点,测试断点正常。

答：

修改gdbinit内容为
```
file bin/kernel
set architecture i8086
target remote :1234
b *0x7c00
continue
```

在lab1目录下执行 make debug ，屏幕显示
```
The target architecture is assumed to be i8086
0x0000fff0 in ?? ()
Breakpoint 1 at 0x7c00

Breakpoint 1, 0x00007c00 in ?? ()
```

在gdb的调试界面输入
```
x /10i $pc
```

屏幕显示
```
=> 0x7c00:    cli    
0x7c01:    cld    
0x7c02:    xor    %eax,%eax
0x7c04:    mov    %eax,%ds
0x7c06:    mov    %eax,%es
0x7c08:    mov    %eax,%ss
0x7c0a:    in     $0x64,%al
0x7c0c:    test   $0x2,%al
0x7c0e:    jne    0x7c0a
0x7c10:    mov    $0xd1,%al
```

### [练习2.3] 在调用qemu 时增加 -d in_asm -D q.log 参数，便可以将运行的汇编指令保存在q.log 中。
将执行的汇编代码与 bootasm.S 和 bootblock.asm 进行比较，看看二者是否一致。

答：

在0x7c00处设置断点，使用 si 单步跟踪，从断点处，q.log记录的前十条代码为：
```
----------------
IN: 
0x00007c00:  fa                       cli      

----------------
IN: 
0x00007c01:  fc                       cld      

----------------
IN: 
0x00007c02:  31 c0                    xorw     %ax, %ax

----------------
IN: 
0x00007c04:  8e d8                    movw     %ax, %ds

----------------
IN: 
0x00007c06:  8e c0                    movw     %ax, %es

----------------
IN: 
0x00007c08:  8e d0                    movw     %ax, %ss

----------------
IN: 
0x00007c0a:  e4 64                    inb      $0x64, %al

----------------
IN: 
0x00007c0c:  a8 02                    testb    $2, %al

----------------
IN: 
0x00007c0e:  75 fa                    jne      0x7c0a

----------------
IN: 
0x00007c10:  b0 d1                    movb     $0xd1, %al

----------------
```

与 bootasm.S 和 bootblock.asm 是一致的。


## [练习3]
分析 bootloader 进入保护模式的过程。

答：

首先对环境进行预处理，将flag置零，段寄存器置零：
```
.globl start
start:
# Assemble for 16-bit mode
.code16
# 将IF位置0,屏蔽掉“可屏蔽中断”,当可屏蔽中断到来时CPU不响应,继续执行原指令
cli 
# 将DF位置0，串操作控制处理方向，从带有最低地址的第一个元素逐个处理
cld                                            

# Set up the important data segment registers (DS, ES, SS).
xorw %ax, %ax                                   # 异或 将%ax置零
movw %ax, %ds                                   # -> Data Segment
movw %ax, %es                                   # -> Extra Segment
movw %ax, %ss                                   # -> Stack Segment
```
开启A20：
```
seta20.1:               # 等待 8042 inutbuffer 为空
    inb $0x64, %al      # 
    testb $0x2, %al     #
    jnz seta20.1        #

    movb $0xd1, %al     # 向8042输出端口写入
    outb %al, $0x64     # 

seta20.1:               # 等待 8042 inputbuffer 为空
    inb $0x64, %al      # 
    testb $0x2, %al     #
    jnz seta20.1        #

    movb $0xdf, %al     # 打开A20
    outb %al, $0x60     # 
```

>注：发现开启A20和键盘控制器是否忙（inputbuffer is empty）并没有什么关系，目的是为了防止被Hack。

初始化GDT表：
```
lgdt gdtdesc
```

进入保护模式：
```
movl %cr0, %eax         # 将cr0的PE位置1
orl $CR0_PE_ON, %eax    #
movl %eax, %cr0         #
```

更新CS，并跳转至32位代码段：
```
ljmp $PROT_MODE_CSEG, $protcseg
```

更新段寄存器：
```
.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment
```

初始化堆栈，进入boot主方法：
```
# Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
movl $0x0, %ebp
movl $start, %esp
call bootmain
```


## [练习4]
分析bootloader加载ELF格式的OS的过程。

答：

bootmain函数分析：
```
/* bootmain - the entry of bootloader */
void
bootmain(void) {
    // 读取ELF的头部
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // 根据头部的成员变量e_magic判断ELF文件是否合法
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    // ph为ELF的首地址
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    // 通过readseg函数（后面分析），将ELF文件中的数据读入内存
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }
    // 根据ELF头部信息进入内核入口
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
outw(0x8A00, 0x8A00);
outw(0x8A00, 0x8E00);

/* do nothing */
while (1);
}
```

readseg函数分析：
```
// 通过readsect函数，从kernel @offset读取@count bytes的扇区内容到@va
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset)
```

readsect函数分析：
```
/* readsect - read a single sector at @secno into @dst */
static void
readsect(void *dst, uint32_t secno) {
    // wait for disk to be ready
    waitdisk();

    // 要读写的扇区数，这里为1
    outb(0x1F2, 1);     
    
    // 设置扇区号
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    
    outb(0x1F7, 0x20);                      // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // 读取一个扇区的内容
    insl(0x1F0, dst, SECTSIZE / 4);
}
```


## [练习5] 
实现函数调用堆栈跟踪函数 

答：

```
/*
栈底方向      高位地址
...
...
参数3
参数2
参数1
返回地址
上一层[ebp]   <-------- [esp/当前ebp]
局部变量      低位地址
参考资料：https://www.jianshu.com/p/8e3c962af1a6
*/
void
print_stackframe(void) {
    /* LAB1 YOUR CODE : STEP 1 */
    uint32_t curr_ebp, curr_eip;
    // (1) call read_ebp() to get the value of ebp. the type is (uint32_t)
    curr_ebp = read_ebp();
    // (2) call read_eip() to get the value of eip. the type is (uint32_t);
    curr_eip = read_eip();
    // (3) from 0 .. STACKFRAME_DEPTH
    for (int stack_level = 0; stack_level <= STACKFRAME_DEPTH; ++stack_level) {
        cprintf("stack_level: %d\n", stack_level);
        // (3.1) printf value of ebp, eip
        cprintf("ebp: 0x%08x eip: 0x%08x ", curr_ebp, curr_eip);
        // (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]
        cprintf("args:");
        // 未定义uint_32与整数的加法，且sizeof(uint_32) == 4，故先转换位指针再做加法。后面同理。
        for (int arg_num = 0; arg_num < 4; ++arg_num)   
            cprintf("0x%8x ", *((uint32_t*)curr_ebp + 2 + arg_num));
        // (3.3) cprintf("\n");
        cprintf("\n");
        // (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
        print_debuginfo(curr_eip);
        // (3.5) popup a calling stackframe
        //           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
        //                   the calling funciton's ebp = ss:[ebp]
        curr_eip = *((uint32_t*)curr_ebp + 1);
        curr_ebp = *((uint32_t*)curr_ebp);
    }
}
```

## [练习6]
完善中断初始化和处理

### [练习6.1] 中断向量表中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

答：

8字节。

低16位和高16位组成偏移量，16..31字节组成段选择子，二者组成中断处理代码的入口。

### [练习6.2] 请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init。

答：

```
/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
     /* LAB1 YOUR CODE : STEP 2 */
     /* (1) Where are the entry addrs of each Interrupt Service Routine (ISR)?
      *     All ISR's entry addrs are stored in __vectors. where is uintptr_t __vectors[] ?
      *     __vectors[] is in kern/trap/vector.S which is produced by tools/vector.c
      *     (try "make" command in lab1, then you will find vector.S in kern/trap DIR)
      *     You can use  "extern uintptr_t __vectors[];" to define this extern variable which will be used later.
      * (2) Now you should setup the entries of ISR in Interrupt Description Table (IDT).
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    // SETGATE(gate, istrap, sel, off, dpl)
    // 定义于kern/mm/mmu.h
    // gate：处理函数的入口地址
    // istrap：系统段设置为1，中断门设置为0
    // sel：段选择子 
    // off：偏移量
    // dpl：特权级
    for (int i = 0; i < 256; ++i) 
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    // T_SWITCH_TOK 定义于kern/trap/trap/h，也可以使用T_SWITCH_TOU
   	// 用于设置用户态到内核态的切换
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
	// load IDT
    lidt(&idt_pd);
}
```

### [练习6.3] 请编程完善trap.c中的中断处理函数trap，在对时钟中断进行处理的部分填写trap函数

答：

```
case IRQ_OFFSET + IRQ_TIMER:
    ++ticks;
    if (ticks % TICK_NUM == 0)
        print_ticks();
    break;
```


## [练习7]

增加syscall功能，即增加一用户态函数（可执行一特定系统调用：获得时钟计数值），当内核初始完毕后，可从内核态返回到用户态的函数，而用户态的函数又通过系统调用得到内核态的服务

答：
