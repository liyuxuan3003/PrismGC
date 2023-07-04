#ifndef GPULITE_H
#define GPULITE_H

#include <stdint.h>

#include "Peripheral.h"

//GPULite DEF
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
    volatile uint32_t PING_PONG;
} GPUType;

#define GPU ((GPUType *)GPU_LITE_BASE)

#define H_DISP 1024
#define V_DISP 600

void WaitRamReady();
void RamWrite(uint32_t x_pos,uint32_t y_pos,uint32_t pixel,uint32_t len);

void LCDBackground(uint32_t color);
void LCDRectangle(uint32_t color,uint32_t x1,uint32_t y1,uint32_t x2,uint32_t y2);
void LCDRectangleDel(uint32_t color,uint32_t x1,uint32_t y1,uint32_t dx,uint32_t dy);
void LCDPixel(uint32_t color,uint32_t x,uint32_t y);
int LCDChar(int x,int y,int c);

void PingPong();

#endif