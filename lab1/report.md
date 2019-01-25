# Lab1 report

## [练习1]

### [练习1.1] 
操作系统镜像文件 ucore.img 是如何一步一步生成的?(需要比较详细地解释 Makefile 中每一条相关命令和命令参数的含义,以及说明命令导致的结果)

答：

    ucore.img的内容由bootblock和kernel组成。

    kernel的生成：
        编译以下文件，生成*.o
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
        将上述文件生成的*.o文件链接生成bin/kernel。

    bootblock的生成：
        编译以下文件，生成*.o
            boot/bootasm.S
            boot/bootmain.c
        将上述文件生成的*.o文件链接生成bin/bootblock。
        将tools/sign.c编译链接为可执行文件，检察生成的bin/bootblock的大小。大小合法则继续。

    ucore.img的生成：
        // 生成10000个512字节的块，块的内容为0。
        dd if=/dev/zero of=bin/ucore.img count=10000 
        // 将bootblock复制到ucore.img的第0块。
        dd if=bin/bootblock of=bin/ucore.img conv=notrunc
        // 从第1块开始拷贝kernel。
        dd if=bin/kernel of=bin/ucore.img seek=1 conv=notrunc


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
