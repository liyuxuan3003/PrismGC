#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <stdint.h>

#include "Peripheral.h"

typedef struct
{
    volatile uint8_t KEY;
} KeyBoardType;

#define KEYBOARD ((KeyBoardType *)KEYBOARD_BASE)

#endif