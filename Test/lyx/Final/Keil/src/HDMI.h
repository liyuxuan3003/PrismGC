#ifndef HDMI_H
#define HDMI_H

#include <stdint.h>

//UART DEF
typedef struct
{
    volatile uint32_t LCD_CMD;
} HDMIType;

#define HDMI_BASE 0x40020000
#define HDMI ((HDMIType *)HDMI_BASE)

#endif