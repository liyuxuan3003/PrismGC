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
    volatile uint32_t HDMI_BUSY;
} GPUType;

#define GPU ((GPUType *)GPU_LITE_BASE)
#define GPU_PIXELS ((uint32_t *)(GPU_LITE_BASE+16*4))

#define PIXELS_MAX 16

#define H_DISP 1024
#define V_DISP 600

void WaitRamReady();
void PingPong();

void LCDBackground(uint32_t color);
void LCDRectangle(uint32_t color,uint32_t x1,uint32_t y1,uint32_t x2,uint32_t y2);
void LCDPixelSquare(uint32_t color,uint32_t x1,uint32_t y1,uint32_t x2,uint32_t y2);
void LCDPixel(uint32_t color,uint32_t x,uint32_t y);
void LCDPixels(const uint32_t *colors,uint32_t x,uint32_t y,uint32_t len);
void LCDCircle(uint32_t color,int32_t x,int32_t y,int32_t r,int32_t pix);

#define CHAR_SCALE_MAX  6
#define CHAR_WIDTH      8

uint8_t LCDChar(uint32_t color,uint32_t colorbck,uint32_t x,uint32_t y,uint8_t scale,uint32_t c);
uint32_t LCDPrintf(uint32_t color,uint32_t colorbck,uint32_t x,uint32_t y,uint8_t scale,
    const char *fmt,...);

#endif