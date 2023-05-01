#include "GPULite.h"

void WaitRamReady()
{
    while(!GPU -> SYS_VAILD) ;
}

void RamWrite(uint32_t x_pos,uint32_t y_pos,uint32_t pixel,uint32_t len,uint32_t sys_wr_len)
{
    GPU -> X_POS = x_pos;
    GPU -> Y_POS = y_pos;
    GPU -> PIXEL = pixel;
    GPU -> LEN = len;
    GPU -> SYS_WR_LEN = sys_wr_len;
    GPU -> ENABLE = 1;
    while(GPU -> BUSY) ;
    GPU -> ENABLE = 0;
}

void LCDBackground(uint32_t color)
{
    RamWrite(0,0,color,H_DISP*V_DISP,256);
}

void LCDRectangle(uint32_t color,uint32_t x1,uint32_t y1,uint32_t x2,uint32_t y2,uint32_t sys_wr_len)
{
    uint32_t len=x2-x1;
    for(uint32_t y=y1;y<=y2;y++)
    {
        RamWrite(x1,y,color,len,sys_wr_len);
    }
}