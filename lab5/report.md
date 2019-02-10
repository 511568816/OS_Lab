# Lab5 report

## [练习1]

### [练习1.1]
**加载应用程序并执行。**

alloc_proc 修改
```
// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
        proc->state = PROC_UNINIT;  // 设置进程为未初始化状态
        proc->pid = -1;             // 未初始化的的进程 id 为 -1
        proc->runs = 0;             // 初始化时间片
        proc->kstack = 0;           // 内存栈的地址
        proc->need_resched = 0;     // 不需要重新调度设
        proc->parent = NULL;        // 父节点设为空
        proc->mm = NULL;            // 虚拟内存设为空
        memset(&(proc->context), 0, sizeof(struct context));    // 无切换内容
        proc->tf = NULL;            // 中断栈帧指针置为空
        proc->cr3 = boot_cr3;       // CR3 寄存器，PDT 的基址
        proc->flags = 0;            // 标志位
        memset(proc->name, 0, PROC_NAME_LEN);   // 进程名
        proc->wait_state = 0;
        proc->cptr = proc->optr = proc->yptr = NULL;
    }
    return proc;
}
```

新增加了两行代码
```
proc->wait_state = 0;
proc->cptr = proc->optr = proc->yptr = NULL;
```

do_fork 修改
```
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
    }
    ret = -E_NO_MEM;

    // 1. call alloc_proc to allocate a proc_struct
    if ((proc = alloc_proc()) == NULL)
        goto fork_out;
    // 设置子进程的父进程
    proc->parent = current;
    // 2. call setup_kstack to allocate a kernel stack for child process
    if (setup_kstack(proc) != 0)
        goto bad_fork_cleanup_proc;
    // 3. call copy_mm to dup OR share mm according clone_flag
    if (copy_mm(clone_flags, proc) != 0)
        goto bad_fork_cleanup_kstack;
    // 4. call copy_thread to setup tf & context in proc_struct
    copy_thread(proc, stack, tf);
    // 5. insert proc_struct into hash_list && proc_list
    bool intr_flag;
    // 进程锁，禁止此时产生中断
    local_intr_save(intr_flag);
    {
        // 由于 ucore 允许嵌套中断,如果不加进程锁可能会产生重复的 pid
        proc->pid = get_pid();
        hash_proc(proc);
        // 设置进程的相关链接
        set_links(proc);
    }
    // 解锁进程锁
    local_intr_restore(intr_flag);
    // 6. call wakeup_proc to make the new child process RUNNABLE
    wakeup_proc(proc);
    // 7. set ret vaule using child proc's pid
    ret = proc->pid;
fork_out:
    return ret;
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
```

将原来的设置进程相关链接的部分分离为一个独立的函数 set_links
```
// set_links - set the relation links of process
static void
set_links(struct proc_struct *proc) {
    list_add(&proc_list, &(proc->list_link));
    proc->yptr = NULL;
    if ((proc->optr = proc->parent->cptr) != NULL) {
        proc->optr->yptr = proc;
    }
    proc->parent->cptr = proc;
    nr_process ++;
}
```

idt_init 修改
```
/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
    extern uintptr_t __vectors[];
    for (int i = 0; i < 256; ++i) 
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    /* LAB5 2017011313 */ 
     //you should update your lab1 code (just add ONE or TWO lines of code), let user app to use syscall to get the service of ucore
     //so you should setup the syscall interrupt gate in here
    // T_SWITCH_TOK 定义于kern/trap/trap/h
   	// 用于设置中断门
    SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
	// load IDT
    lidt(&idt_pd);
}
```

增加了一行
```
SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
```

trap_dispatch 的 case IRQ_OFFSET + IRQ_TIMER 部分修改为
```
case IRQ_OFFSET + IRQ_TIMER:
    ++ticks;
    if (ticks % TICK_NUM == 0) {
        // 当前进程的时间片用完了
        current->need_resched = 1;
    }
    break;
```

load_icode 中设置 tf 的部分
```
tf->tf_cs = USER_CS;
tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
tf->tf_esp = USTACKTOP;
tf->tf_eip = elf->e_entry;
tf->tf_eflags = FL_IF;
```

### [练习1.2]
**描述当创建一个用户态进程并加载了应用程序后，CPU是如何让这个应用程序最终在用户态执行起来的。即这个用户态进程被ucore选择占用CPU执行（RUNNING态）到具体执行应用程序第一条指令的整个经过。**

1. proc_init 创建了两个进程，分别为：idle、init。其中 idle 为闲置进程。

2. init 调用函数 init_main ，在 init_main 中，创建了新的线程 user_main 。

    dowait -> schedule -> proc_run -> switch_to -> user_main

3. user_main 调用 KERNEL_EXECVE 宏，执行 kernel_execve ，传入用户程序 elf 的首地址和长度，然后系统调用产生软中断。

4. 在 trap_dispatch 中进入syscall ，然后转入 do_execve 。

5. do_execve 中的 load_icode 解析 elf 格式的用户程序，替换当前 tf ，在中断返回时，即直接进入用户程序。

**load_icode 创建了一个能够让用户进程正常运行的用户环境，完成了如下工作：**

1. 调用mm_create函数来申请进程的内存管理数据结构mm所需内存空间，并对mm进行初始化。

2. 调用setup_pgdir来申请一个页目录表所需的一个页大小的内存空间，并把描述ucore内核虚空间映射的内核页表（boot_pgdir所指）的内容拷贝到此新目录表中，最后让mm->pgdir指向此页目录表，这就是进程新的页目录表了，且能够正确映射内核虚空间。

3. 根据应用程序执行码的起始位置来解析此ELF格式的执行程序，并调用mm_map函数根据ELF格式的执行程序说明的各个段（代码段、数据段、BSS段等）的起始位置和大小建立对应的vma结构，并把vma插入到mm结构中，从而表明了用户进程的合法用户态虚拟地址空间。

4. 调用根据执行程序各个段的大小分配物理内存空间，并根据执行程序各个段的起始位置确定虚拟地址，并在页表中建立好物理地址和虚拟地址的映射关系，然后把执行程序各个段的内容拷贝到相应的内核虚拟地址中，至此应用程序执行码和数据已经根据编译时设定地址放置到虚拟内存中了。

5. 需要给用户进程设置用户栈，为此调用mm_mmap函数建立用户栈的vma结构，明确用户栈的位置在用户虚空间的顶端，大小为256个页，即1MB，并分配一定数量的物理内存且建立好栈的虚地址<-->物理地址映射关系。

6. 至此,进程内的内存管理vma和mm数据结构已经建立完成，于是把mm->pgdir赋值到cr3寄存器中，即更新了用户进程的虚拟内存空间，此时的initproc已经被hello的代码和数据覆盖，成为了第一个用户进程，但此时这个用户进程的执行现场还没建立好。

7. 先清空进程的中断帧，再重新设置进程的中断帧，使得在执行中断返回指令“iret”后，能够让CPU转到用户态特权级，并回到用户态内存空间，使用用户态的代码段、数据段和堆栈，且能够跳转到用户进程的第一条指令执行，并确保在用户态能够响应中断。


## [练习2]

### [练习2.1]
**父进程复制自己的内存空间给子进程。**

copy_range 部分增加
```
void * kva_src = page2kva(page); // 返回父进程的内核虚拟页地址  
void * kva_dst = page2kva(npage); // 返回子进程的内核虚拟页地址  
memcpy(kva_dst, kva_src, PGSIZE); // 复制父进程到子进程  
ret = page_insert(to, npage, start, perm); // 建立子进程页地址起始位置与物理地址的映射关系(prem 是权限)
```

### [练习2.2]
**简要说明如何设计实现”Copy on Write 机制“，给出概要设计。**

在 copy_range 中，不进行复制，将 pde_t *to（子进程） 赋值为 pde_t *from（父进程），并将该页的写入位置0（只读）。在需要写时会产生缺页错误，此时在 do_pgfault 中给子进程创建 PTE ，并取代原先 PDE 中的项。

## [练习3]
**阅读分析源代码，理解进程执行 fork/exec/wait/exit 的实现，以及系统调用的实现。**

**fork 分析**

fork -> sys_fork -> syscall(SYS_fork) -> trap_dispatch -> do_fork

1. 分配并初始化进程控制块(alloc_proc 函数)。
2. 分配并初始化内核栈(setup_stack 函数)。
3. 根据 clone_flag 标志复制或共享进程内存管理结构(copy_mm 函数)。
4. 设置进程在内核(将来也包括用户态)正常运行和调度所需的中断帧和执行上下文(copy_thread 函数)。
5. 把设置好的进程控制块放入 hash_list 和 proc_list 两个全局进程链表中。
6. 自此,进程已经准备好执行了,把进程状态设置为“就绪”态。
7. 设置返回码为子进程的 id 号。

**exec 分析**

exec -> ... -> do_execve

do_execve 主要完成了两件事：

1. 调用 exit_mmap、put_pgdir、mm_destroy 删除并释放掉当前进程内存空间的页表信息、内存管理信息。

2. 调用 load_icode 加载 ELF 格式的用户程序。

**wait 分析**

wait -> ... -> do_wait

循环查询子进程的状态，直到一个正在等待的子进程的状态变成 Zombie 状态，这时完成这个子进程的剩余资源回收工作，释放子进程的空间。

do_wait 代码分析
```
// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int
do_wait(int pid, int *code_store) {
    struct mm_struct *mm = current->mm;
    if (code_store != NULL) {
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
            return -E_INVAL;
        }
    }

    struct proc_struct *proc;
    bool intr_flag, haskid;
repeat:
    haskid = 0;
    // 如果 pid!=0，表示只找一个进程 id 号为 pid 的退出状态的子进程，否则找任意一个处于退出状态的子进程
    if (pid != 0) {
        proc = find_proc(pid);
        if (proc != NULL && proc->parent == current) {
            haskid = 1;
            if (proc->state == PROC_ZOMBIE) {
                goto found;
            }
        }
    }
    else {
        proc = current->cptr;
        for (; proc != NULL; proc = proc->optr) {
            haskid = 1;
            if (proc->state == PROC_ZOMBIE) {
                goto found;
            }
        }
    }
    // 如果此子进程的执行状态不为 PROC_ZOMBIE，表明此子进程还没有退出
    if (haskid) {
        // 当前进程设置执行状态为 PROC_SLEEPING（睡眠)
        current->state = PROC_SLEEPING;
        // 睡眠原因为 WT_CHILD (即等待子进程退出)
        current->wait_state = WT_CHILD;
        // 调用schedule()函数选择新的进程执行
        schedule();
        if (current->flags & PF_EXITING) {
            do_exit(-E_KILLED);
        }
        goto repeat;
    }
    return -E_BAD_PROC;

// 找到处于退出状态的子进程
found:
    if (proc == idleproc || proc == initproc) {
        panic("wait idleproc or initproc.\n");
    }
    if (code_store != NULL) {
        *code_store = proc->exit_code;
    }
    // 把子进程控制块从两个进程队列proc_list和hash_list中删除，并释放子进程的内核堆栈和进程控制块
    local_intr_save(intr_flag);
    {
        unhash_proc(proc);
        remove_links(proc);
    }
    local_intr_restore(intr_flag);
    put_kstack(proc);
    kfree(proc);
    return 0;
}
```

**exit 分析**

exit -> ... -> do_exit

回收当前进程所占的大部分内存资源,并通知父进程完成最后的回收工作。

do_exit 代码分析
```
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
    // 先判断是否是用户进程，如果是，则开始回收此用户进程所占用的用户态虚拟内存空间
    if (current == idleproc) {
        panic("idleproc exit.\n");
    }
    if (current == initproc) {
        panic("initproc exit.\n");
    }
    
    struct mm_struct *mm = current->mm;
    if (mm != NULL) {
        lcr3(boot_cr3);
        if (mm_count_dec(mm) == 0) {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
    }
    // 设置当前进程状态为PROC_ZOMBIE
    current->state = PROC_ZOMBIE;
    // 设置当前进程的退出码为error_code
    current->exit_code = error_code;
    
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
    {
        proc = current->parent;
        if (proc->wait_state == WT_CHILD) {
            // 唤醒父进程，让父进程来帮子进程完成最后的资源回收工作
            wakeup_proc(proc);
        }
        // 如果当前进程还有子进程,则需要把这些子进程的父进程指针设置为内核线程 init
        while (current->cptr != NULL) {
            proc = current->cptr;
            current->cptr = proc->optr;
    
            proc->yptr = NULL;
            if ((proc->optr = initproc->cptr) != NULL) {
                initproc->cptr->yptr = proc;
            }
            proc->parent = initproc;
            initproc->cptr = proc;
            if (proc->state == PROC_ZOMBIE) {
                if (initproc->wait_state == WT_CHILD) {
                    wakeup_proc(initproc);
                }
            }
        }
    }
    local_intr_restore(intr_flag);
    
    schedule();
    panic("do_exit will not return!! %d.\n", current->pid);
}
```

**系统调用的实现**

通过软中断发起系统调用，进入 syscall()，由于参数不同，可以调用不同的功能。

**请给出ucore中一个用户态进程的执行状态生命周期图（包执行状态，执行状态之间的变换关系，以及产生变换的事件或函数调用）。（字符方式画即可）**

![状态生命周期图](https://upload-images.jianshu.io/upload_images/8878550-f94af7f2702c5c90.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/556 "状态图")

进程创建(fork()函数) -> 进程就绪（proc -> state == RUNNABLE）-> 进程执行（schedule()函数) -> 进程退出（do_exit()） -> 进程结束(do_wait()回收kstack和proc_struct)
