# Lab8 report

## [练习1] 完成读文件操作的实现

### [练习1.1]
**首先了解打开文件的处理流程，然后参考本实验后续的文件读写操作的过程分析，编写在sfs_inode.c中sfs_io_nolock读文件中数据的实现代码。**

`sfs_io_nolock` 这个函数的功能是将磁盘中的一段数据读入到内存中或者将内存中的一段数据写入磁盘。需要补充的部分如下：
```
static int
sfs_io_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, void *buf, off_t offset, size_t *alenp, bool write) {
    ...
    int ret = 0;
    size_t size, alen = 0;
    uint32_t ino;
    uint32_t blkno = offset / SFS_BLKSIZE;          // The NO. of Rd/Wr begin block
    uint32_t nblks = endpos / SFS_BLKSIZE - blkno;  // The size of Rd/Wr blocks

  //LAB8:EXERCISE1 2017011313 HINT: call sfs_bmap_load_nolock, sfs_rbuf, sfs_rblock,etc. read different kind of blocks in file
	/*
	 * (1) If offset isn't aligned with the first block, Rd/Wr some content from offset to the end of the first block
	 *       NOTICE: useful function: sfs_bmap_load_nolock, sfs_buf_op
	 *               Rd/Wr size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset)
	 * (2) Rd/Wr aligned blocks 
	 *       NOTICE: useful function: sfs_bmap_load_nolock, sfs_block_op
     * (3) If end position isn't aligned with the last block, Rd/Wr some content from begin to the (endpos % SFS_BLKSIZE) of the last block
	 *       NOTICE: useful function: sfs_bmap_load_nolock, sfs_buf_op	
	*/
    // 读取第一页，可能不对齐
    if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) 
        goto out;
    blkoff = offset % SFS_BLKSIZE;
    // 计算第一个块的大小
    size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
    if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) {
        goto out;
    }
    alen += size;
    // 如果超过一页的话
    if (nblks != 0) {
        // 读取第二页到第 n-1 页，这些页大小均为 SFS_BLKSIZE
        for (int i = blkno + 1; i < blkno + nblks; ++i) {
            if ((ret = sfs_bmap_load_nolock(sfs, sin, i, &ino)) != 0) {
                goto out;
            }
            if ((ret = sfs_block_op(sfs, buf + alen, ino, 1)) != 0) {
                goto out;
            }
            alen += SFS_BLKSIZE;
        }
        // 读取最后一页，可能不对齐
        if (endpos % SFS_BLKSIZE != 0) {
            if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno + nblks, &ino)) != 0) {
                goto out;
            }
            if ((ret = sfs_buf_op(sfs, buf + alen, endpos % SFS_BLKSIZE, ino, 0)) != 0) {
                goto out;
            }
            alen += endpos % SFS_BLKSIZE;
        }
    }
out:
    *alenp = alen;
    if (offset + alen > sin->din->size) {
        sin->din->size = offset + alen;
        sin->dirty = 1;
    }
    return ret;
}
```

该函数前面部分的作用是用于检查对文件的操作是否会发生溢出，分别有防止写溢出、读溢出，然后判断是读操作,还是写操作。由于存储的文件大小不一定是（而且大概率不是）SFS_BLKSIZE 的倍数，所以头尾所处的 block 只有部分属于他们，所以需要使用 `sfs_buf_op` 操作相应的部分。对于中间部分，他们都完整的占据了一个 block ，所以使用 `sfs_block_op` 操作整块的内容。

### [练习1.2]
**请在实验报告中给出设计实现”UNIX的PIPE机制“的概要设方案，鼓励给出详细设计方案。**

管道的作用是做进程通讯。当我们需要将一个文件中的内容作为另一个文件的输入，或者将一个程序运行的结果作为另一个程序的输入时，就会需要使用管道：

1. 使用 pipe 建立一个管道。 

2. 使用 fork 建立一个子进程，他们共同享有管道的读和写。 

3. 将一个进程的标准输入改为管道的读，另一个进程的标准输出改为管道的写。 

4. 使用 exec 运行所需要的程序。

UNIX 中，PIPE 也被认为是一种文件。根据 STDIN, STDOUT 和 SFS ，可以将 PIPE 作为与这三者并列的结构体。因此在初始化 STDIN, STDOUT 时，需要同时初始化 PIPE ，并为其创建 inode 。同时由于 PIPE 需要能够缓存输入，需要为其分配一片内存。为了让用户进程能够使用 PIPE ，需要添加相应的系统调用：

* 将 PIPE 和两个进程相连
* 向 PIPE 中写入数据
* 从 PIPE 中读出数据

## [练习2] 完成基于文件系统的执行程序机制的实现

### [练习2.1]
**改写proc.c中的load_icode函数和其他相关函数，实现基于文件系统的执行程序机制。**

alloc_proc 增加 fs 的初始化：
```
static struct proc_struct *
alloc_proc(void) {
    ······
        proc->filesp = NULL; // 初始化 fs 中的进程控制结构
    }
    return proc;
}
```

do_fork 中需要将父进程的文件系统信息复制到子进程中：
```
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    ...
    if (copy_fs(clone_flags, proc) != 0) { 
            goto bad_fork_cleanup_kstack;
        }
    if (copy_mm(clone_flags, proc) != 0)
        goto bad_fork_cleanup_fs;
    ...
}
```
loadicode 完成的主要是：

* 建立内存管理器
* 建立页目录
* 从硬盘上读取程序到内存
* 建立好相应的虚拟内存映射表
* 建立并初始化用户堆栈
* 处理用户栈中传入的参数
* 设置好进程中断栈

load_icode 分析：
```
static int
load_icode(int fd, int argc, char **kargv) {
    /* LAB8:EXERCISE2 2017011313  HINT:how to load the file with handler fd  in to process's memory? how to setup argc/argv?
     * MACROs or Functions:
     *  mm_create        - create a mm
     *  setup_pgdir      - setup pgdir in mm
     *  load_icode_read  - read raw data content of program file
     *  mm_map           - build new vma
     *  pgdir_alloc_page - allocate new memory for  TEXT/DATA/BSS/stack parts
     *  lcr3             - update Page Directory Addr Register -- CR3
     */
	/* (1) create a new mm for current process
     * (2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
     * (3) copy TEXT/DATA/BSS parts in binary to memory space of process
     *    (3.1) read raw data content in file and resolve elfhdr
     *    (3.2) read raw data content in file and resolve proghdr based on info in elfhdr
     *    (3.3) call mm_map to build vma related to TEXT/DATA
     *    (3.4) callpgdir_alloc_page to allocate page for TEXT/DATA, read contents in file
     *          and copy them into the new allocated pages
     *    (3.5) callpgdir_alloc_page to allocate pages for BSS, memset zero in these pages
     * (4) call mm_map to setup user stack, and put parameters into user stack
     * (5) setup current process's mm, cr3, reset pgidr (using lcr3 MARCO)
     * (6) setup uargc and uargv in user stacks
     * (7) setup trapframe for user environment
     * (8) if up steps failed, you should cleanup the env.
     */
    if (current->mm != NULL) {
        panic("load_icode: current->mm must be empty.\n");
    }
    int ret = -E_NO_MEM;
    struct mm_struct *mm;
    // (1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }

    // (2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if (setup_pgdir(mm) != 0) {
        goto bad_pgdir_cleanup_mm;
    }

    // (3) copy TEXT/DATA/BSS parts in binary to memory space of process
    struct Page *page;

    // (3.1) read raw data content in file and resolve elfhdr
    struct elfhdr __elf, *elf = &__elf;
    ret = load_icode_read(fd, elf, sizeof(struct elfhdr), 0);
    if (ret != 0) {
        goto bad_elf_cleanup_pgdir;
    }

    if (elf -> e_magic != ELF_MAGIC) {
        ret = -E_INVAL_ELF;
        goto bad_elf_cleanup_pgdir;
    }

    struct proghdr __ph, *ph = &__ph;
    uint32_t vm_flags, perm, phnum;
    for (phnum = 0; phnum < elf->e_phnum; phnum ++) {
        // (3.2) read raw data content in file and resolve proghdr based on info in elfhdr
        off_t phoff = elf->e_phoff + sizeof(struct proghdr) * phnum;
        if ((ret = load_icode_read(fd, ph, sizeof(struct proghdr), phoff)) != 0) {
            goto bad_cleanup_mmap;
        }
        if (ph->p_type != ELF_PT_LOAD) {
            continue ;
        }
        if (ph->p_filesz > ph->p_memsz) {
            ret = -E_INVAL_ELF;
            goto bad_cleanup_mmap;
        }
        if (ph->p_filesz == 0) {
            continue ;
        }
        vm_flags = 0, perm = PTE_U;
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
        if (vm_flags & VM_WRITE) perm |= PTE_W;
       
        // (3.3) call mm_map to build vma related to TEXT/DATA
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
            goto bad_cleanup_mmap;
        }
        off_t offset = ph->p_offset;
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);

        ret = -E_NO_MEM;

        // (3.4) callpgdir_alloc_page to allocate page for TEXT/DATA, read contents in file
        end = ph->p_va + ph->p_filesz;
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                ret = -E_NO_MEM;
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la) {
                size -= la - end;
            }
            if ((ret = load_icode_read(fd, page2kva(page) + off, size, offset)) != 0) {
                goto bad_cleanup_mmap;
            }
            start += size, offset += size;
        }
        end = ph->p_va + ph->p_memsz;

        // (3.5) callpgdir_alloc_page to allocate pages for BSS, memset zero in these pages
        if (start < la) {
            if (start == end) {
                continue ;
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
            if (end < la) {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                ret = -E_NO_MEM;
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la) {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }
    sysfile_close(fd);

    // (4) call mm_map to setup user stack, and put parameters into user stack
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
        goto bad_cleanup_mmap;
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);

    // (5) setup current process's mm, cr3, reset pgidr (using lcr3 MARCO)
    mm_count_inc(mm);
    current->mm = mm;
    current->cr3 = PADDR(mm->pgdir);
    lcr3(PADDR(mm->pgdir));

    // (6) setup uargc and uargv in user stacks
    uint32_t argv_size=0, i;
    for (i = 0; i < argc; i ++) {
        argv_size += strnlen(kargv[i],EXEC_MAX_ARG_LEN + 1)+1;
    }

    uintptr_t stacktop = USTACKTOP - (argv_size/sizeof(long)+1)*sizeof(long);
    char** uargv=(char **)(stacktop  - argc * sizeof(char *));

    argv_size = 0;
    for (i = 0; i < argc; i ++) {
        uargv[i] = strcpy((char *)(stacktop + argv_size ), kargv[i]);
        argv_size +=  strnlen(kargv[i],EXEC_MAX_ARG_LEN + 1)+1;
    }

    stacktop = (uintptr_t)uargv - sizeof(int);
    *(int *)stacktop = argc;

    // (7) setup trapframe for user environment
    struct trapframe *tf = current->tf;
    memset(tf, 0, sizeof(struct trapframe));
    tf->tf_cs = USER_CS;
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
    tf->tf_esp = stacktop;
    tf->tf_eip = elf->e_entry;
    tf->tf_eflags = FL_IF;
    ret = 0;

    // (8) if up steps failed, you should cleanup the env.
out:
    return ret;
bad_cleanup_mmap:
    exit_mmap(mm);
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
}
```

### [练习2.2]
**请在实验报告中给出设计实现基于”UNIX的硬链接和软链接机制“的概要设方案，鼓励给出详细设计方案。**

#### 硬链接
文件 A 是文件 B 的硬链接，则A的目录项中的 inode 节点号与 B 节点的 inode 节点号相同，既一个 inode 节点对应两个不同的文件名，两个文件名指向一个同一个文件， A 和 B 对于文件系统其实是完全相同的。 如果删除了其中一个，对另外一个没有影响. 每增加一个文件名， inode 节点上的链接数增加一，每删除一个对应的文件名， inode 节点上的链接数减一，直到为 0 ， inode 节点和对应数据块被回收。

#### 软链接
A 是 B 的软链接， A 的目录项中的 inode 节点号与 B 的目录项中的 inode 节点号不同， A 和 B 指向的是两个不同的 inode ，继而指向两块不同的数据块，但是 A 的数据块存放的只是 B 的路径名。 A 和 B 之间 “主从”关系，如果 B 被删除了， A 仍然存在，但指向的是一个无效的链接。

#### 硬链接机制的设计实现

vfs 中预留了硬链接的实现接口 `int vfs_link(char *old_path, char *new_path)` 。在实现硬链接机制，创建硬链接 link 时，为 new_path 创建对应的 file ，并把其 inode 指向 old_path 所对应的 inode ， inode 的引用计数加 1 。在 unlink 时将引用计数减去1即可。

#### 软链接机制的设计实现

vfs 中预留了软链接的实现接口 `int vfs_symlink(char *old_path, char *new_path)` 。在实现软链接机制，创建软连接 link 时，创建一个新的文件（inode 不同），并把 old_path 的内容存放到文件的内容中去，给该文件保存在磁盘上时 disk_inode 类型为 SFS_TYPE_LINK ，再完善对于该类型 inode 的操作即可。 unlink 时类似于删除一个普通的文件。