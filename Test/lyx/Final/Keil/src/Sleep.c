#include "Sleep.h"

void Delay(int interval) 
{
    volatile int i = 0;
    while(1) 
    {
        i++;
        if(i>=interval) break;
    }
}