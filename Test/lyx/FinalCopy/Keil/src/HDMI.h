#ifndef HDMI_H
#define HDMI_H

#include <stdint.h>

#include "Peripheral.h"

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

#define HDMI ((HDMIType *)HDMI_BASE)

#define H_DISP 1024
#define V_DISP 600

void RamReady();
void RamWrite(uint32_t x_pos,uint32_t y_pos,uint32_t pixel,uint32_t len,uint32_t sys_wr_len);

void LCDBackground(uint32_t color);
void LCDRectangle(uint32_t color,uint32_t x1,uint32_t y1,uint32_t x2,uint32_t y2,uint32_t sys_wr_len);

#endif