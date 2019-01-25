# Lab1 report

## [练习1]

### [练习1.1] 
操作系统镜像文件 ucore.img 是如何一步一步生成的?(需要比较详细地解释 Makefile 中每一条相关命令和命令参数的含义,以及说明命令导致的结果)

答：

ucore.img 的内容由 bootblock 和 kernel 组成。

>kernel 的生成

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

>bootblock的生成

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

>ucore.img 的生成

Makefile 代码
```
# create ucore.img
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

[练习2.1] 从 CPU 加电后执行的第一条指令开始,单步跟踪 BIOS 的执行。

答：

[练习2.2] 在初始化位置0x7c00 设置实地址断点,测试断点正常。

答：

[练习2.3] 在调用qemu 时增加-d in_asm -D q.log 参数，便可以将运行的汇编指令保存在q.log 中。
将执行的汇编代码与bootasm.S 和 bootblock.asm 进行比较，看看二者是否一致。

答：


## [练习3]
分析bootloader 进入保护模式的过程。

答：


## [练习4]
分析bootloader加载ELF格式的OS的过程。

答：


## [练习5] 
实现函数调用堆栈跟踪函数 

答：


## [练习6]
完善中断初始化和处理

[练习6.1] 中断向量表中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

答：

[练习6.2] 请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init。

答：

[练习6.3] 请编程完善trap.c中的中断处理函数trap，在对时钟中断进行处理的部分填写trap函数

答：


## [练习7]

增加syscall功能，即增加一用户态函数（可执行一特定系统调用：获得时钟计数值），当内核初始完毕后，可从内核态返回到用户态的函数，而用户态的函数又通过系统调用得到内核态的服务

答：
