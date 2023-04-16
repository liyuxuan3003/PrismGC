#ifndef HDMI_H
#define HDMI_H

#include <stdint.h>

//HDMI DEF
typedef struct
{
    volatile uint32_t X_POS;
    volatile uint32_t Y_POS;
    volatile uint32_t PIXEL;
    volatile uint32_t LEN;
    volatile uint32_t ENABLE;
    volatile uint32_t SYS_WR_LEN;
    volatile uint32_t SYS_VAILD;
    volatile uint32_t BUSY;
} HDMIType;

#define HDMI_BASE 0x40020000
#define HDMI ((HDMIType *)HDMI_BASE)

#endif