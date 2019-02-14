# Lab7 report

## [练习0] 填写已有实验

需要改进的函数为 trap_dispatch
```
case IRQ_OFFSET + IRQ_TIMER:
    ++ticks;
    run_timer_list();
    break;
```


## [练习1] 理解内核级信号量的实现和基于内核级信号量的哲学家就餐问题

### [练习1.1]
**给出内核级信号量的设计描述，并说其大致执行流程。**

semaphore_t 结构体
```
typedef struct {
    // 计数器
    int value;
    // 等待队列
    wait_queue_t wait_queue;
} semaphore_t;
```

P 操作：down -> _down
```
static __noinline uint32_t __down(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    // 关中断
    local_intr_save(intr_flag);
    // 资源没有被占用
    if (sem->value > 0) {
        sem->value --;
        local_intr_restore(intr_flag);
        return 0;
    }
    // sem->value <= 0 表示资源被占用
    wait_t __wait, *wait = &__wait;
    // 加入等待队列
    wait_current_set(&(sem->wait_queue), wait, wait_state);
    // 开中断
    local_intr_restore(intr_flag);
    // 调度
    schedule();
    // 再次被调度到，即被 V 操作唤醒
    local_intr_save(intr_flag);
    // 从等待队列中删除
    wait_current_del(&(sem->wait_queue), wait);
    local_intr_restore(intr_flag);

    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}
```

V 操作：up->_up
```
static __noinline void __up(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        wait_t *wait;
        // 等待队列为空
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
            sem->value ++;
        }
        // 有正在等待使用资源的进程
        else {
            assert(wait->proc->wait_state == wait_state);
            // 将等待队列中的首元素删除，并将该进程唤醒
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);
        }
    }
    local_intr_restore(intr_flag);
}
```

philosopher_using_semaphore 分析
```
int philosopher_using_semaphore(void * arg) /* i：哲学家号码，从0到N-1 */
{
    int i, iter=0;
    i=(int)arg;
    cprintf("I am No.%d philosopher_sema\n",i);
    while(iter++<TIMES)
    { /* 无限循环 */
        cprintf("Iter %d, No.%d philosopher_sema is thinking\n",iter,i); /* 哲学家正在思考 */
        do_sleep(SLEEP_TIME);
        phi_take_forks_sema(i); 
        /* 需要两只叉子，或者阻塞 */
        cprintf("Iter %d, No.%d philosopher_sema is eating\n",iter,i); /* 进餐 */
        do_sleep(SLEEP_TIME);
        phi_put_forks_sema(i); 
        /* 把两把叉子同时放回桌子 */
    }
    cprintf("No.%d philosopher_sema quit\n",i);
    return 0;    
}
```

phi_test_sema 分析
```
void phi_test_sema(i) /* i：哲学家号码从0到N-1 */
{ 
    if(state_sema[i]==HUNGRY&&state_sema[LEFT]!=EATING
            &&state_sema[RIGHT]!=EATING)
    {
        // 修改该哲学家的状态
        state_sema[i]=EATING;
        // 表示该哲学家已经获得了叉子
        up(&s[i]);
    }
}
```

phi_take_forks_sema 分析
```
void phi_take_forks_sema(int i) /* i：哲学家号码从0到N-1 */
{ 
    down(&mutex); /* 进入临界区 */
    state_sema[i]=HUNGRY; /* 记录下哲学家i饥饿的事实 */
    phi_test_sema(i); /* 试图得到两只叉子 */
    up(&mutex); /* 离开临界区 */
    down(&s[i]); /* 如果得不到叉子就阻塞 */
}
```

左顾右盼邻居的同时，更改他们的状态，让他们获取叉子（up(&s[i])）
```
void phi_put_forks_sema(int i) /* i：哲学家号码从0到N-1 */
{ 
    down(&mutex); /* 进入临界区 */
    state_sema[i]=THINKING; /* 哲学家进餐结束 */
    phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
    phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
    up(&mutex); /* 离开临界区 */
}
```

### [练习1.2]
**比较说明用户级信号量和内核级信号量的异同**

1. 内核态信号量存储在内核态的内核栈上，而用户态信号量存储在内核中一段共享内存中。

2. 用户态使用信号量时，需要进行系统调用进入到内核态进行操作。

3. 用户态的进行/线程的信号量的数据结构和内核级的是一样的，但是可能涉及到多个内核临界区，因此用户级的信号量可能包含一个内核级信号量数组。

**给出给用户态进程/线程提供信号量机制的设计方案。**

定义如下接口：

- sem_open：创建一个信号量并将其返回以供后续调用，将该信号量放置在内核态的一段共享内存中。

- sem_close：删除一个信号量。

- sem_p/sem_v：P/V 操作，对结构体中的每个内核级信号量单独执行操作。

- sem_getvalue：获取信号量当前的值。


## [练习2] 完成内核级条件变量和基于内核级条件变量的哲学家就餐问题

### [练习2.1]
**首先掌握管程机制，然后基于信号量实现完成条件变量实现，然后用管程机制实现哲学家就餐问题的解决方案（基于条件变量）。**

cond_signal 分析
```
// 唤醒睡在条件变量上的线程
void 
cond_signal (condvar_t *cvp) {
    cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
    // 如果 cvp->count 不大于 0 ，表示当前没有因为执行 cond_wait 而睡眠的进程，因此没有需要被唤醒的对象，可以直接返回
    // 如果 cvp->count 大于 0 ，表示存在因为执行 cond_wait 而睡眠的进程 A
    if(cvp->count>0) {
        // 等待被唤醒的进程数加一
        cvp->owner->next_count ++;
        // 唤醒进程 A 
        up(&(cvp->sem));
        // 由于只允许有一个进程在管程中执行，所以需要将自身睡眠（阻塞），在 monitor->next->wait_queue 队列中等待被唤醒
        down(&(cvp->owner->next));
        // 自己已经被唤醒，等待被唤醒的进程数减一
        cvp->owner->next_count --;
    }
    cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}
```

cond_wait 分析
```
void
cond_wait (condvar_t *cvp) {
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
    // 等待此条件（cvp）的睡眠进程数需要加一 
    ++cvp->count;
    // 如果 cvp->owner->next_count > 0 ，表示至少有一个进程因为执行 cond_signal 函数而睡着（阻塞）了，需要将其唤醒
    if(cvp->owner->next_count > 0)
        up(&(cvp->owner->next));
    // 否则表示没有进程因为执行 cond_signal 函数而睡着（阻塞），需要唤醒因为互斥条件限制而无法进入管程的进程
    else
        up(&(cvp->owner->mutex));
    // 将自身阻塞
    down(&(cvp->sem));
    // 被唤醒，等待此条件（cvp）的睡眠进程数需要减一 
    --cvp->count;
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}
```

为了让管程能够正常运行，需要在函数的入口和出口增加相关操作，模板如下：
```
function (…) {
    sem.wait(monitor.mutex);

    the real body of function;

    if(monitor.next_count > 0)
        sem_signal(monitor.next);
    else
        sem_signal(monitor.mutex);
}
```

phi_take_forks_condvar 分析
```
void phi_take_forks_condvar(int i) {
    down(&(mtp->mutex));
//--------into routine in monitor--------------
    // I am hungry
    state_condvar[i] = HUNGRY;
    // 尝试获得叉子
    phi_test_condvar(i);
    // 如果没取得叉子
    if (state_condvar[i] != EATING) {
        // 得不到叉子就阻塞
        cond_wait(&mtp->cv[i]);
    }
//--------leave routine in monitor--------------
    if(mtp->next_count>0)
        up(&(mtp->next));
    else
        up(&(mtp->mutex));
}
```

phi_put_forks_condvar 分析
```
void phi_put_forks_condvar(int i) {
    down(&(mtp->mutex));
//--------into routine in monitor--------------
    // LAB7 EXERCISE1: YOUR CODE
    // I ate over
    state_condvar[i]=THINKING;
    // test left and right neighbors
    phi_test_condvar(LEFT);
    phi_test_condvar(RIGHT);
//--------leave routine in monitor--------------
    if(mtp->next_count>0)
        up(&(mtp->next));
    else
        up(&(mtp->mutex));
}
```

### [练习2.1]
**比较说明用户级提供条件变量机制和内核级提供条件变量机制的异同**

1. 内核态条件变量存储在内核态的内核栈上，而用户态条件变量存储在内核中一段共享内存中。

2. 用户态使用条件变量时，需要进行系统调用进入到内核态进行操作。

3. 用户态的进程/线程的条件变量的数据结构和内核级的是一样的，但是可能涉及到多个内核临界区，因此用户级的条件变量可能包含一个内核级条件变量数组。

**给出给用户态进程/线程提供条件变量机制的设计方案。**

定义如下接口，：

- condvar_init：创建条件变量并初始化，将该条件变量放置在内核态的一段共享内存中。

- condvar_destroy：删除一个条件变量。

- condvar_wait/condvar_signal：wait 和 signal 操作的接口。

### [练习2.2]
**能否不用基于信号量机制来完成条件变量？如果不能，请给出理由，如果能，请给出设计说明和具体实现。**

能。可以通过打开/使能中断实现 cond_wait 和 cond_signal 的原子操作。具体实现参考 __up 、 __down 。

首先修改 condvar_t 结构体
```
typedef struct {
    int count;
    wait_queue_t wait_queue;
} cond_t;
```

__wait 分析
```
static __noinline uint32_t __wait(cond_t *cond, uint32_t wait_state) {
    bool intr_flag;
    // 关闭中断
    local_intr_save(intr_flag);
    // 当前资源空闲
    if (cond->count == 0) {
        ++cond->count;
        local_intr_restore(intr_flag);
        return 0;
    }
    wait_t __wait, *wait = &__wait;
    ++cond->count;
    // 加入等待队列
    wait_current_set(&(cond->wait_queue), wait, wait_state);
    local_intr_restore(intr_flag);

    schedule();

    local_intr_save(intr_flag);
    // 从等待队列中删除
    wait_current_del(&(wait->wait_queue), wait);
    --cond->count;
    local_intr_restore(intr_flag);

    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}

void
cond_wait(cond_t *cond) {
    uint32_t flags = __wait(cond, WT_KCOND);
    assert(flags == 0);
}
```

__signal 分析
```
static __noinline void __signal(cond_t *cond, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        wait_t *wait;
        // 唤醒等待队列中的第一个进程
        if ((wait = wait_queue_first(&(cond->wait_queue))) != NULL) {
            assert(wait->proc->wait_state == wait_state);
            wakeup_wait(&(cond->wait_queue), wait, wait_state, 1);
        }
    }
    local_intr_restore(intr_flag);
}

void
cond_signal(semaphore_t *cond) {
    __signal(cond, WT_KCOND);
}
```