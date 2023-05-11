#ifndef TIMER_H
#define TIMER_H

#include <stdint.h>

#include "Peripheral.h"

typedef struct
{
    volatile uint32_t TIME;
} TimerType;

#define TIMER ((TimerType *)TIMER_BASE)

#endif