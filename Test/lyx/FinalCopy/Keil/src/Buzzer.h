#ifndef BUZZER_H
#define BUZZER_H

#include <stdint.h>

#include "Peripheral.h"

typedef struct
{
    volatile uint32_t NOTE:3;
    volatile uint32_t NC:29;
    volatile uint32_t TIME;
} BuzzerType;

#define BUZZER ((BuzzerType *)BUZZER_BASE)

#endif