# Lab4 report

## [练习1]

### [练习1.1]
**分配并初始化一个进程控制块。**

alloc_proc函数（位于kern/process/proc.c中）负责分配并返回一个新的struct proc_struct结构，用于存储新建立的内核线程的管理信息。ucore需要对这个结构进行最基本的初始化，你需要完成这个初始化过程。

alloc_proc 分析
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
    }
    return proc;
}
```

### [练习1.2]
**请说明proc_struct中struct context context和struct trapframe *tf成员变量含义和在本实验中的作用是什么？**

1. struct context context 是进程的上下文，用于进程的切换。用于保存前一个进程的现场（各个寄存器的状态）。

2. struct trapframe *tf 是中断栈帧，用于中断的处理、切换。保存了中断信息。

（提示通过看代码和编程调试可以判断出来）

## [练习2]

### [练习2.1]
**为新创建的内核线程分配资源**

do_fork 分析
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
        list_add(&proc_list, &(proc->list_link));
        nr_process ++;
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

### [练习2.2]
**请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。**

是的。虽然 get_pid() 操作的是全局变量，但是由于增加了进程锁，所以产生的 pid 是唯一的。

## [练习3]

### [练习3.1]
**阅读代码，理解 proc_run 函数和它调用的函数如何完成进程切换的。**

proc_run 分析
```
void
proc_run(struct proc_struct *proc) {
    // 如果要调度的进程不是当前进程
    if (proc != current) {
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
        // 关闭中断，防止进程调度的过程中产生其他中断，导致嵌套的进程调度
        local_intr_save(intr_flag);
        {
            // 当前进程设置为待调度进程
            current = proc;
            // 加载内核栈基地址
            load_esp0(next->kstack + KSTACKSIZE);
            // 加载页表基地址
            lcr3(next->cr3);
            // 保存原现成的寄存器，并设置当前进程的寄存器
            switch_to(&(prev->context), &(next->context));
        }
        local_intr_restore(intr_flag);
    }
}
```

### [练习3.2]
**在本实验的执行过程中，创建且运行了几个内核线程？**

两个。

- idleproc：ucore的第一个内核线程，完成内核中各个子系统的初始化，之后立即调度，执行其他进程。

- initproc：“hello world”线程。

### [练习3.2]
**语句local_intr_save(intr_flag);....local_intr_restore(intr_flag);在这里有何作用?请说明理由**

在进程调度前禁止产生中断，防止产生嵌套的进程调度。同时防止其他进程修改全局变量。
