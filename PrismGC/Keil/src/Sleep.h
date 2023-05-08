#ifndef SLEEP_H
#define SLEEP_H

#define TICKS 10000000

void Delay(unsigned int interval);

static inline void udelay(unsigned int us)
{
    unsigned int count=us*50/5;
    while(count)
    {
        count--;
        __asm("nop");
    }
}
static inline void mdelay(unsigned int ms)
{
    unsigned int count=ms*50000/5;
    while(count)
    {
        count--;
        __asm("nop");
    }
}
#endif