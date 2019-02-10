#include <defs.h>
#include <list.h>
#include <proc.h>
#include <assert.h>
#include <default_sched.h>

static void
RR_init(struct run_queue *rq) {
    // 初始化进程队列
    list_init(&(rq->run_list));
    // 初始进程数为 0
    rq->proc_num = 0;
}

static void
RR_enqueue(struct run_queue *rq, struct proc_struct *proc) {
    assert(list_empty(&(proc->run_link)));
    // 把新进程加到队列末尾
    list_add_before(&(rq->run_list), &(proc->run_link));
    // 如果进程时间片等于 0 或大于时间片限制
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
        proc->time_slice = rq->max_time_slice;
    }
    // 设置进程所属队列
    proc->rq = rq;
    // 就绪进程数加一
    rq->proc_num ++;
}

static void
RR_dequeue(struct run_queue *rq, struct proc_struct *proc) {
    // 进程控制块指针非空并且进程属于该就绪队列中
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
    // 将进程从就绪队列中删除
    list_del_init(&(proc->run_link));
    // 就绪进程数减一
    rq->proc_num --;
}

static struct proc_struct *
RR_pick_next(struct run_queue *rq) {
    // 选取就绪队列的首元素
    list_entry_t *le = list_next(&(rq->run_list));
    // 只要还有就绪进程就返回该进程
    if (le != &(rq->run_list)) {
        return le2proc(le, run_link);
    }
    // 否则返回 NULL
    return NULL;
}

static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
    // 还有剩余时间片
    if (proc->time_slice > 0) {
        proc->time_slice --;
    }
    // 时间片已用完
    if (proc->time_slice == 0) {
        // 进程需要重新调度
        proc->need_resched = 1;
    }
}

struct sched_class default_sched_class = {
    .name = "RR_scheduler",
    .init = RR_init,
    .enqueue = RR_enqueue,
    .dequeue = RR_dequeue,
    .pick_next = RR_pick_next,
    .proc_tick = RR_proc_tick,
};

