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
    // 读取第一块的数据
    if ((blkoff = offset % SFS_BLKSIZE) != 0) {
        // 计算第一个块的大小
        size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
        // 读取第一个块
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        // 完成对第一块的读写操作
        if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) {
            goto out;
        }
        alen += size;
        if (nblks == 0) {
            goto out;
        }
        buf += size, blkno ++, nblks --;
    }
    // 读取中间完整块（大小为 SFS_BLKSIZE）的数据
    for (int i = blkno + 1; i < blkno + nblks; ++i) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, i, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_block_op(sfs, buf + alen, ino, 1)) != 0) {
            goto out;
        }
        alen += SFS_BLKSIZE;
    }
    // 读取最后一块的数据
    if ((size = endpos % SFS_BLKSIZE) != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0) {
            goto out;
        }
        alen += size;
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

### [练习2.2]
**请在实验报告中给出设计实现基于”UNIX的硬链接和软链接机制“的概要设方案，鼓励给出详细设计方案。**