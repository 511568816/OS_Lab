# Lab2 report

## [练习1]
实现 first-fit 连续物理内存分配算法

答：

```
在实现first fit 内存分配算法的回收函数时，要考虑地址连续的空闲块之间的合并操作。提示:在建立空闲页块链表时，需要按照空闲页块起始地址来排序，形成一个有序的链表。可能会修改default_pmm.c中的default_init，default_init_memmap，default_alloc_pages， default_free_pages等相关函数。请仔细查看和理解default_pmm.c中的注释。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

你的first fit算法是否有进一步的改进空间
```

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

```
typedef struct {
    list_entry_t free_list;         // the list header
    unsigned int nr_free;           // # of free pages in this free list
                                    // 当前空闲页的个数
} free_area_t;
```

```
/* 
    if this bit=1: 
    the Page is the head page of a free memory block
    (contains some continuous_addrress pages),
    and can be used in alloc_pages 
    标记当前页为一片连续 block 的头，且可以被分配
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