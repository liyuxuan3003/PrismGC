typedef struct
{
    volatile uint32_t TIME;
} TimerType;

#define TIMER ((TimerType *)TIMER_BASE)