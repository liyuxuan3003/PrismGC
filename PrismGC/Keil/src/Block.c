#include "Block.h"

#include "GlobalDefine.h"

#include "GPULite.h"
#include "Charactors.h"

#include "Console.h"
#include "Sleep.h"
#include <math.h>

void BlockICE(uint32_t x,uint32_t y)
{
    LCDRectangle(COLOR_ICE,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    // for(int i=0;i<BLOCK_INNE-8;i++)
    // {
    //     LCDPixel(0xFFFFFF,x-i-4,y-BLOCK_INNE+i+4);
    //     LCDPixel(0xFFFFFF,x-i-4,y+i+4);
    //     LCDPixel(0xFFFFFF,x-i-4+BLOCK_INNE,y-BLOCK_INNE+i+4);
    //     LCDPixel(0xFFFFFF,x-i-4+BLOCK_INNE,y+4+i);
    // }
    return;
}

void BlockBAR(uint32_t x,uint32_t y)
{
    // LCDRectangle(COLOR_BAR,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}

void BlockEND(uint32_t x,uint32_t y)
{
    LCDRectangle(COLOR_END,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}

void BlockANM(uint32_t x,uint32_t y)
{
    LCDRectangle(COLOR_ANM,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}

void BlockMCG(uint32_t x,uint32_t y)
{
    LCDRectangle(COLOR_MCG,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}

void BlockDIR(uint32_t x,uint32_t y,uint32_t z)
{
    LCDRectangle(COLOR_DIR,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    Arrow(x,y,z,COLOR_DIR_ARR);
    return;
}

void BlockGRA(uint32_t x,uint32_t y,uint8_t hit)
{
    LCDRectangle(COLOR_GRA_BUT,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    LCDRectangle(COLOR_GRA,x-BLOCK_INNE+BLOCK_BORD,y-BLOCK_INNE+BLOCK_BORD,x+BLOCK_INNE-BLOCK_BORD,y+BLOCK_INNE-BLOCK_BORD);
    if(hit)
    {
       LCDPixelSquare(COLOR_GRA_BUT,x+2,y-BLOCK_INNE+BLOCK_BORD,x+6,y-BLOCK_INNE+BLOCK_BORD+20); 
       LCDPixelSquare(COLOR_GRA_BUT,x+6,y-6,x+BLOCK_INNE-BLOCK_BORD,y-2);
       LCDPixelSquare(COLOR_GRA_BUT,x,y+4,x+4,y+8);
       LCDPixelSquare(COLOR_GRA_BUT,x-2,y+8,x+2,y+BLOCK_INNE-BLOCK_BORD);
       LCDPixelSquare(COLOR_GRA_BUT,x-8,y+8,x-2,y+12);
       LCDPixelSquare(COLOR_GRA_BUT,x-12,y+6,x-6,y+10);
       LCDPixelSquare(COLOR_GRA_BUT,x-BLOCK_INNE+BLOCK_BORD,y+4,x-12,y+8);
    }
}

void BlockPOR(uint32_t x,uint32_t y,uint32_t id)
{
    uint32_t colorInn;
    switch (id)
    {
        case 1: colorInn=COLOR_POR_SY1; ndelay(100); break;
        case 2: colorInn=COLOR_POR_SY2; ndelay(100); break;
        case 3: colorInn=COLOR_POR_SY3; ndelay(100); break;
    }
    LCDRectangle(COLOR_POR,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    LCDRectangle(colorInn ,x-(BLOCK_INNE-4),y-(BLOCK_INNE-4),x+(BLOCK_INNE-4),y+(BLOCK_INNE-4));
    LCDRectangle(COLOR_POR,x-(BLOCK_INNE-8),y-(BLOCK_INNE-8),x+(BLOCK_INNE-8),y+(BLOCK_INNE-8));
    // for(uint32_t i=5;i<=15;i++)
    // {
    //     for(int j=-2;j<=2;j++)
    //     {
    //         LCDPixel(colorInn,x+i,y+j);
    //         LCDPixel(colorInn,x-i,y+j);
    //         LCDPixel(colorInn,x+j,y+i);
    //         LCDPixel(colorInn,x+j,y-i);
    //         LCDPixel(colorInn,x+i*0.7-j,y+i*0.7+j);
    //         LCDPixel(colorInn,x-i*0.7+j,y+i*0.7+j);
    //         LCDPixel(colorInn,x+i*0.7+j,y-i*0.7+j);
    //         LCDPixel(colorInn,x-i*0.7+j,y-i*0.7-j);
    //     }
    // }
    //     for(uint32_t i=5;i<=15;i++)
    // {
    //     LCDPixel(colorInn,x+i,y);
    //     LCDPixel(colorInn,x-i,y);
    //     LCDPixel(colorInn,x,y+i);
    //     LCDPixel(colorInn,x,y-i);
    //     LCDPixel(colorInn,x+i*0.7,y+i*0.7);
    //     LCDPixel(colorInn,x-i*0.7,y+i*0.7);
    //     LCDPixel(colorInn,x+i*0.7,y-i*0.7);
    //     LCDPixel(colorInn,x-i*0.7,y-i*0.7);
    // }
}



void BlockDOR(uint32_t x,uint32_t y,uint32_t opensign)
{
    BlockICE(x,y);
    
    // 0是关闭
    // 1是半开
    // 2是全开

    if(opensign<=2)
    {
        LCDRectangle(COLOR_DOR,x-BLOCK_INNE,y-BLOCK_INNE,x-BLOCK_INNE+6,y+BLOCK_INNE);
        LCDRectangle(COLOR_DOR,x+BLOCK_INNE-6,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    }

    if(opensign<=1)
    {
        LCDRectangle(COLOR_DOR_BOARD,x-BLOCK_INNE+4+2,y-BLOCK_INNE+4,x-BLOCK_INNE+9+2,y+BLOCK_INNE-4);
        LCDRectangle(COLOR_DOR_BOARD,x+BLOCK_INNE-9-2,y-BLOCK_INNE+4,x+BLOCK_INNE-4-2,y+BLOCK_INNE-4);
        LCDRectangle(COLOR_DOR,x-BLOCK_INNE,y-12,x-BLOCK_INNE+16,y-8);
        LCDRectangle(COLOR_DOR,x-BLOCK_INNE,y+8,x-BLOCK_INNE+16,y+12);
        LCDRectangle(COLOR_DOR,x+BLOCK_INNE-16,y-12,x+BLOCK_INNE,y-8);
        LCDRectangle(COLOR_DOR,x+BLOCK_INNE-16,y+8,x+BLOCK_INNE,y+12);

    }

    if(opensign==0)
    {
        LCDRectangle(COLOR_DOR_BOARD,x-BLOCK_INNE+12+2,y-BLOCK_INNE+4,x-BLOCK_INNE+17+2,y+BLOCK_INNE-4);
        LCDRectangle(COLOR_DOR_BOARD,x+BLOCK_INNE-17-2,y-BLOCK_INNE+4,x+BLOCK_INNE-12-2,y+BLOCK_INNE-4);
        LCDRectangle(COLOR_DOR,x-BLOCK_INNE+10,y-12,x,y-8);
        LCDRectangle(COLOR_DOR,x-BLOCK_INNE+10,y+8,x,y+12);
        LCDRectangle(COLOR_DOR,x,y-12,x+BLOCK_INNE-10,y-8);
        LCDRectangle(COLOR_DOR,x,y+8,x+BLOCK_INNE-10,y+12);
    }

    return;
}

void BlockTRP(uint32_t x,uint32_t y)
{
    BlockICE(x,y);
    LCDRectangle(COLOR_BAR,x-8,y-9,x+7,y-8);
    LCDRectangle(COLOR_BAR,x-10,y-7,x+7,y-7);
    LCDRectangle(COLOR_TRP,x-6,y-7,x+5,y-7);
    LCDRectangle(COLOR_BAR,x-12,y-6,x+9,y-6);
    LCDRectangle(COLOR_TRP,x-8,y-6,x+7,y-6);
    LCDRectangle(COLOR_BAR,x-14,y-5,x+10,y-5);
    LCDRectangle(COLOR_TRP,x-12,y-5,x+8,y-5);
    LCDRectangle(COLOR_BAR,x-15,y-4,x+11,y-4);
    LCDRectangle(COLOR_TRP,x-13,y-4,x+9,y-4);
    LCDRectangle(COLOR_BAR,x-15,y-3,x+11,y-3);
    LCDRectangle(COLOR_TRP,x-13,y-3,x+9,y-3);
    LCDRectangle(COLOR_BAR,x-17,y-2,x+12,y-2);
    LCDRectangle(COLOR_TRP,x-15,y-2,x+10,y-2);
    LCDRectangle(COLOR_BAR,x-17,y-1,x+14,y-1);
    LCDRectangle(COLOR_TRP,x-15,y-1,x+10,y-1);
    LCDRectangle(COLOR_BAR,x-18,y-0,x+16,y-0);
    LCDRectangle(COLOR_TRP,x-16,y-0,x+12,y-0);
    LCDRectangle(COLOR_BAR,x,y+1,x+17,y+1);
    LCDRectangle(COLOR_TRP,x-15,y+1,x+15,y+1);
    LCDRectangle(COLOR_BAR,x,y+2,x+17,y+2);
    LCDRectangle(COLOR_TRP,x-14,y+2,x+15,y+2);
    LCDRectangle(COLOR_TRP,x-13,y+3,x+16,y+3);
    LCDRectangle(COLOR_TRP,x-12,y+4,x+16,y+4);
    LCDRectangle(COLOR_TRP,x-11,y+5,x+14,y+5);
    LCDRectangle(COLOR_TRP,x-10,y+6,x+14,y+6);
    LCDRectangle(COLOR_TRP,x-9,y+7,x+12,y+7);
    LCDRectangle(COLOR_TRP,x-9,y+8,x+12,y+8);
    LCDRectangle(COLOR_TRP,x-8,y+9,x+9,y+9);
    LCDRectangle(COLOR_TRP,x-6,y+10,x+7,y+10);
    return;
}

void BlockBUT(uint32_t x,uint32_t y,uint32_t opensign)
{
    LCDRectangle(COLOR_POR,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);

    uint32_t color;
    switch (opensign)
    {
        case 0: color=COLOR_BUT_CLOSE; break;
        case 1: color=COLOR_BUT_EXCUTING; break;
        case 2: color=COLOR_BUT_OPEN; break;
    }
    LCDCircle(color*0.8,x,y,16,1);
    LCDCircle(color,x,y,12,1);
}