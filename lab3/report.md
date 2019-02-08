# Lab3 report

## [练习1]

### [练习1.1]
**给未被映射的地址映射上物理页。**

do_pgfault 分析
```
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
    int ret = -E_INVAL;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
    pgfault_num++;
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
        goto failed;
    }
    //check the error_code
    switch (error_code & 3) {
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
        goto failed;
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
            goto failed;
        }
    }
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
        perm |= PTE_W;
    }
    addr = ROUNDDOWN(addr, PGSIZE);
    ret = -E_NO_MEM;
    pte_t *ptep=NULL;

    /*LAB3 EXERCISE 1: YOUR CODE*/
    
    // (1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (1) 尝试寻找 pte，如果 pte 不存在，就创建一个
    // 所以第三个参数是 1
    ptep = get_pte(mm->pgdir, addr, 1);
    if (ptep == NULL) {
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }
    // (2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    // 找到了正确的入口，但是物理页面不存在，需要创建
    if (*ptep == 0) {
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
            goto failed;
        }
    }
    // 页表项非空，尝试换入页面 
    else {
        if(swap_init_ok) {
            struct Page *page = NULL;
            // 把将要使用的页面从硬盘中交换至内存中
            if (swap_in(mm, addr, &page) != 0) {
                cprintf("pgdir_alloc_page in do_pgfault failed\n");
                goto failed;
            }
            // 将页面物理地址与逻辑地址建立联系
            page_insert(mm->pgdir, page, addr, perm);
            // 将页面属性设置为：可被交换的
            swap_map_swappable(mm, addr, page, 1);
            // 设置给算法使用的变量：逻辑地址
            page->pra_vaddr = addr;
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
    }
   ret = 0;
failed:
    return ret;
}
```

### [练习1.2] 
**请描述页目录项（Page Directory Entry）和页表项（Page Table Entry）中组成部分对ucore实现页替换算法的潜在用处。**

PTE、PDE 每一位的详细用处已于 lab2 report 中写出。

PDE 用于寻找 PTE ，PTE 用于判断物理页面是否存在。如果不存在，则需要给 PDT 分配一个页面，并建立物理地址和逻辑地址之间的联系。


### [练习1.3]
**如果ucore的缺页服务例程在执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？**

1. 将发生异常的地址保存到 CR2 寄存器，同时将 EFLAG、CS、EIP、ErrorCode 等保存至内核栈。

2. 将页访问异常的中断服务例程的地址加载到 CS 和 EIP。

## [练习2]

### [练习2.1]
**补充完成基于FIFO的页面替换算法。**

fifo_map_swappable 分析
```
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
 
    assert(entry != NULL && head != NULL);
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2017011313*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    // 将 page 的 list entry 加入到 head 后面
    list_add(head, entry);
    return 0;
}
```

fifo_swap_out_victim 分析
```
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
         assert(head != NULL);
     assert(in_tick==0);
     /* Select the victim */
     /*LAB3 EXERCISE 2: 2017011313*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page

     // 找到队尾元素的 list entry
     list_entry_t *tail_le = head->prev;
     struct Page *tail_page = le2page(tail_le, pra_page_link);
     // 删除队尾元素
     list_del(tail_le);
     // 把从内存中删除的页面内容保存到 ptr_page
     *ptr_page = tail_page;
     return 0;
}
```


### [练习2.2]
**如果要在ucore上实现"extended clock页替换算法"请给你的设计方案，现有的swap_manager框架是否足以支持在ucore中实现此算法？如果是，请给你的设计方案。如果不是，请给出你的新的扩展和基此扩展的设计方案。并需要回答如下问题**

1. 需要被换出的页的特征是什么？
2. 在ucore中如何判断具有这样特征的页？
3. 何时进行换入和换出操作？

足以实现，详细参见 Challenge 1 。

1. 访问位（PTE_A）为 0，修改位（PTE_D）为 0。
2. 通过 *pte & PTE_A 和 *pte & PTE_D 是否为 0 判断。
3. 在缺页的时候换入，在 swap_out_victim 时换出。

## Challenge 1
**实现识别dirty bit的 extended clock页替换算法。**

需要修改 swap_out、_fifo_swap_out_victim。

swap_out
```
int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
     {
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
          if (r != 0) {
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
                  break;
          }
     }
     return i;
}
```

_fifo_swap_out_victim
```
void save_page(struct mm_struct *mm, struct Page *page) {
    uintptr_t v = page->pra_vaddr; 
    pte_t *ptep = get_pte(mm->pgdir, v, 0);
    assert((*ptep & PTE_P) != 0);
    swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page);
    cprintf("swap_out: store page in vaddr 0x%x to disk swap entry %d\n", v, page->pra_vaddr/PGSIZE+1);
}

static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
         assert(head != NULL);
     assert(in_tick==0);
    list_entry_t *le;
    struct Page *page;
    pte_t *pte;
    while (1) {
        le = head->next;
        while (le != head) {
            page = le2page(le, pra_page_link);
            pte = get_pte(mm->pgdir, page->pra_vaddr, 0);
            // 如果最近访问过
            if (*pte & PTE_A) {
                *pte &= ~PTE_A;
            }
            // 如果最近没有访问过
            else {
                // 如果最近修改过
                if (*pte & PTE_D) {
                    save_page(mm, page);
                    *pte &= ~PTE_D;
                }
                // 如果最近没有修改过
                else {
                    goto save;
                }
            }
            le = list_next(le);
        }
    }
save:
    list_del(le);
    *pte = (page->pra_vaddr/PGSIZE+1)<<8;
    free_page(page);
    tlb_invalidate(mm->pgdir, page->pra_vaddr);
    return 0;
}
```

> 其余部分无需修改。这里虽然函数名没有修改，仍然为 fifo ，但是已经为 extended_clock 算法
