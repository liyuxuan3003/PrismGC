#ifndef HDMI_H
#define HDMI_H

#include <stdint.h>

#include "Peripheral.h"

//HDMI DEF
typedef struct
{
    volatile uint32_t PIXEL;
    volatile uint32_t X_POS;
    volatile uint32_t Y_POS;
} HDMIType;

#define HDMI ((HDMIType *)HDMI_BASE)

#endif