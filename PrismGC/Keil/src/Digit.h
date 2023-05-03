#ifndef DIGIT_H
#define DIGIT_H

#include <stdint.h>

#include "Peripheral.h"

typedef struct
{
    volatile uint8_t COD:4;
    volatile uint8_t DOT:1;
    volatile uint8_t ENA:1;
    volatile uint8_t REV:2;
} DigitType;

#define DIG ((DigitType *)DIGIT_BASE)
#define DIG_CRTL *((uint8_t *)(DIGIT_BASE+0x4))

#endif