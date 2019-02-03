# Lab2 report

## [练习1]

### 实现 first-fit 连续物理内存分配算法

答：

相关内容理解（定义于 mm/memlayout.c）

Page 结构体
```
struct Page {
    int ref;                        // page frame's reference counter
                                    // 页被页表的引用记数，即映射此物理页的虚拟页个数
    uint32_t flags;                 // array of flags that describe the status of the page frame
                                    // 此物理页的状态标记，有两个标志位
                                    // 第一个表示是否被保留（reserved）
                                    // 第二个表示此页是否可被分配（free）
    unsigned int property;          // the num of free block, used in first fit pm manager
                                    // 某连续内存空闲块的大小
    list_entry_t page_link;         // free list link
                                    // 便于把多个连续内存空闲块链接在一起的双向链表指针
};
```

free_area_t 结构体
```
typedef struct {
    list_entry_t free_list;         // the list header
    unsigned int nr_free;           // # of free pages in this free list
                                    // 当前空闲页的个数
} free_area_t;
```

PG_property 变量
```
/* 
    if this bit=1: 
    the Page is the head page of a free memory block
    (contains some continuous_addrress pages),
    and can be used in alloc_pages 
    标记当前页为一片连续 block 的头，且可以被分配，即 PG_property = 1
*/
SetPageProperty(page);
```

default_init_memmap 分析
```
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        // 保证本页是保留页
        assert(PageReserved(p));
        p->flags = p->property = 0;
        // 清空引用
        set_page_ref(p, 0);
    }
    // 连续内存空闲块的大小为n，属于物理页管理链表
    base->property = n;
    // 除了首位的base，其他块均不是 the head page of a free memory block
    // 参考 mm/memlatput.h 中 PG_property 的定义
    SetPageProperty(base);
    // 有n个free块
    nr_free += n;
    // 插入空闲页的链表里面
    list_add_before(&free_list, &(base->page_link)); 
}
```

default_alloc_pages 分析
```
static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);
    // 如果所有的空闲页的加起来的大小都不够，则返回 NULL
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    // 找到 first fit
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
        // 保证当前页面可以被分配
        assert(PageProperty(page));
        // 如果找到的 page 过大，则需要分割
        if (page->property > n) {
            struct Page *p = page + n;
            // 分为大小为 n 的部分和剩余部分
            p->property = page->property - n;
            // 设置 p 开头的页可以被分配
            SetPageProperty(p);
            // 将 p 插入 list
            list_add_after(&(page->page_link), &(p->page_link));
        }
        list_del(&(page->page_link));
        nr_free -= n;
        // 设置为不可被分配
        ClearPageProperty(page);
    }
    return page;
}
```

default_free_pages 分析
```
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    // 把将要回收的 n 个块进行 init
    for (; p != base + n; ++p) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    nr_free += n;
    // 把将要回收的块插入合适的位置
    while (le != &free_list) {                      
        p = le2page(le, page_link);                 
        // 使得插入后地址是从低到高的
        if (base + base->property <= p) {           
            break;                                  
        }                                           
        le = list_next(le);                         
    }                                            
    // 考虑和前面的 page 合并
    p = le2page(list_prev(le), page_link);
    if (p + p->property == base) {
        p->property += base->property;
        ClearPageProperty(base);
        base = p;
        list_del(&(p->page_link));
    }
    // 考虑和后面的 page 合并
    p = le2page(le, page_link); 
    if (base + base->property == p) {
        base->property += p->property;
        ClearPageProperty(p);
        le = list_next(le);
        list_del(&(p->page_link));
    }
    list_add_before(le, &(base->page_link));
}
```

### first fit 算法改进

原代码在 free 时，两次寻找 base 的插入位置。
这里改进为只需要查找一次。
具体方法在“default_free_pages 分析”中有详细注释。


## [练习2]

### [练习2.1]
实现寻找虚拟地址对应的页表项

get_pte 分析
```
    // (1) find page directory entry
    // pdep: page_directory_entry_pointer
    pde_t *pdep = pgdir + PDX(la);
    // (2) check if entry is not present
    if (!(*pdep & PTE_P)) {
        // (3) check if creating is needed, then alloc page for page table
        if (!create)
            return NULL;
        struct Page *page = alloc_page();
        // 如果分配页失败
        if (page == NULL)
            return NULL;
        // (4) set page reference
        set_page_ref(page, 1);
        // (5) get linear address of page
        uintptr_t pa = page2pa(page);
        // (6) clear page content using memset
        memset(KADDR(pa), 0, PGSIZE);
        // (7) set page directory entry's permission
        *pdep = pa | PTE_U | PTE_W | PTE_P;
    }
    // (8) return page table entry
    return (pte_t *)KADDR(PDE_ADDR(*pdep)) + PTX(la);
}
```

### [练习2.2]
请描述页目录项（Page Director Entry）和页表（Page Table Entry）中每个组成部分的含义和以及对ucore而言的潜在用处。

Page Table Entry

|名称|地址|ucore 中对应|含义|
|--                   |--    |--        |--                                         |
|Present              |0     |PTE_P     |是否保存在物理内存中                          |
|Writeable            |1     |PTE_W     |是否可写                                    |
|User/Supervisor      |2     |PTE_U     |访问权限                                    |
|Write Through        |3     |PTE_PWT   |表示 CPU 可以直接写回内存                     |
|Cache Disabled       |4     |PTE_PCD   |是否需要被 CPU 缓存                          |
|Accessed             |5     |PTE_A     |该页是否被写过                               |
|Dirty                |6     |PTE_D     |页面读取内容后，相应内容被修改了                |
|0                    |7     |PTE_MBZ   |必须是0                                     |
|Global               |8     |          |在 CR3 寄存器更新时无需刷新 TLB 中关于该页的地址 |
|Avail                |9..11 |PTE_AVAIL |保留给软件使用                               |
|Physical Page Address|12..31|          |指明 PTE 基质地址                            |

Page Director Entry

|名称|地址|ucore 中对应|含义|
|--                   |--    |--        |--                                         |
|Present              |0     |PTE_P     |是否保存在物理内存中                          |
|Writeable            |1     |PTE_W     |是否可写                                    |
|User/Supervisor      |2     |PTE_U     |访问权限                                    |
|Write Through        |3     |PTE_PWT   |表示 CPU 可以直接写回内存                     |
|Cache Disabled       |4     |PTE_PCD   |是否需要被 CPU 缓存                          |
|Accessed             |5     |PTE_A     |该页是否被写过                               |
|0                    |6     |PTE_MBZ   |必须是0                                     |
|Page Size            |7     |PTE_PS    |页面大小                                    |
|Ignored              |8     |          |                                           |
|Avail                |9..11 |PTE_AVAIL |保留给软件使用                               |
|Physical Page Address|12..31|          |指明 PTE 基质地址                            |

### [练习2.3]
如果ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？

1. 将引发页访问异常的地址将被保存在cr2寄存器中。
2. 触发14号中断（缺页错误）。


## [练习3]
释放某虚地址所在的页并取消对应二级页表项的映射
```
当释放一个包含某虚地址的物理内存页时，需要让对应此物理内存页的管理数据结构Page做相关的清除处理，使得此物理内存页成为空闲；另外还需把表示虚地址与物理地址对应关系的二级页表项清除。请仔细查看和理解page_remove_pte函数中的注释。为此，需要补全在 kern/mm/pmm.c中的page_remove_pte函数。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？
如果希望虚拟地址与物理地址相等，则需要如何修改lab2，完成此事？ 鼓励通过编程来具体完成这个问题
```

## Challenge 1
buddy system（伙伴系统）分配算法
```
Buddy System算法把系统中的可用存储空间划分为存储块(Block)来进行管理, 每个存储块的大小必须是2的n次幂(Pow(2, n)), 即1, 2, 4, 8, 16, 32, 64, 128...
参考伙伴分配器的一个极简实现， 在ucore中实现buddy system分配算法，要求有比较充分的测试用例说明实现的正确性，需要有设计文档。
```

## Challenge 2
任意大小的内存单元slub分配算法
```
slub算法，实现两层架构的高效内存单元分配，第一层是基于页大小的内存分配，第二层是在第一层基础上实现基于任意大小的内存分配。可简化实现，能够体现其主体思想即可。
参考linux的slub分配算法/，在ucore中实现slub分配算法。要求有比较充分的测试用例说明实现的正确性，需要有设计文档。
```
> Challenges是选做，做一个就很好了。完成Challenge的同学可单独提交Challenge。完成得好的同学可获得最终考试成绩的加分。