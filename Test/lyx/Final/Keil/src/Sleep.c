#include "Sleep.h"

void Delay(int interval) 
{
    volatile int i = 0;
    while(1) 
    {
        i = i + 1;
        if(i == interval) break;
    }
}