#include <stdio.h>
#include <monitor.h>
#include <kmalloc.h>
#include <assert.h>


// Initialize monitor.
void     
monitor_init (monitor_t * mtp, size_t num_cv) {
    int i;
    assert(num_cv>0);
    mtp->next_count = 0;
    mtp->cv = NULL;
    sem_init(&(mtp->mutex), 1); //unlocked
    sem_init(&(mtp->next), 0);
    mtp->cv =(condvar_t *) kmalloc(sizeof(condvar_t)*num_cv);
    assert(mtp->cv!=NULL);
    for(i=0; i<num_cv; i++){
        mtp->cv[i].count=0;
        sem_init(&(mtp->cv[i].sem),0);
        mtp->cv[i].owner=mtp;
    }
}

// Unlock one of threads waiting on the condition variable. 
// 唤醒睡在条件变量上的线程
void 
cond_signal (condvar_t *cvp) {
    //LAB7 EXERCISE1: 2017011313
    cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
    /*
    *      cond_signal(cv) {
    *          if(cv.count>0) {
    *             mt.next_count ++;
    *             signal(cv.sem);
    *             wait(mt.next);
    *             mt.next_count--;
    *          }
    *       }
    */
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

// Suspend calling thread on a condition variable waiting for condition Atomically unlocks 
// mutex and suspends calling thread on conditional variable after waking up locks mutex. Notice: mp is mutex semaphore for monitor's procedures
void
cond_wait (condvar_t *cvp) {
    //LAB7 EXERCISE1: 2017011313
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
   /*
    *         cv.count ++;
    *         if(mt.next_count>0)
    *            signal(mt.next)
    *         else
    *            signal(mt.mutex);
    *         wait(cv.sem);
    *         cv.count --;
    */
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
