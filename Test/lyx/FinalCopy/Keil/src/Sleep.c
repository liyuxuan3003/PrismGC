#include "Sleep.h"

void Delay(unsigned int interval) 
{
    volatile unsigned int i = 0;
    while(1) 
    {
        i++;
        if(i>=interval) break;
    }
}