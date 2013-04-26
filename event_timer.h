void *eventtimer_new();

void eventtimer_push_event(
    void *ti,
    int nsecs,
    void *udata,
    void (*func) (void *)
);

void eventtimer_step(void *ti);

