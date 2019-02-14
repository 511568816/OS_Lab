#include <defs.h>
#include <wait.h>
#include <atomic.h>
#include <kmalloc.h>
#include <sem.h>
#include <proc.h>
#include <sync.h>
#include <assert.h>

void
sem_init(semaphore_t *sem, int value) {
    sem->value = value;
    wait_queue_init(&(sem->wait_queue));
}

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

void
up(semaphore_t *sem) {
    __up(sem, WT_KSEM);
}

void
down(semaphore_t *sem) {
    uint32_t flags = __down(sem, WT_KSEM);
    assert(flags == 0);
}

bool
try_down(semaphore_t *sem) {
    bool intr_flag, ret = 0;
    local_intr_save(intr_flag);
    if (sem->value > 0) {
        sem->value --, ret = 1;
    }
    local_intr_restore(intr_flag);
    return ret;
}

