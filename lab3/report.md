# Lab3 report

## [练习1]

### [练习1.1]
**给未被映射的地址映射上物理页。**

```
完成do_pgfault（mm/vmm.c）函数，给未被映射的地址映射上物理页。设置访问权限 的时候需要参考页面所在 VMA 的权限，同时需要注意映射物理页时需要操作内存控制 结构所指定的页表，而不是内核的页表。
```

```
请描述页目录项（Page Directory Entry）和页表项（Page Table Entry）中组成部分对ucore实现页替换算法的潜在用处。
如果ucore的缺页服务例程在执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？
```

do_pgfault 分析
```
/*LAB3 EXERCISE 1: YOUR 2017011313*/
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
***如果要在ucore上实现"extended clock页替换算法"请给你的设计方案，现有的swap_manager框架是否足以支持在ucore中实现此算法？如果是，请给你的设计方案。如果不是，请给出你的新的扩展和基此扩展的设计方案。并需要回答如下问题***

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