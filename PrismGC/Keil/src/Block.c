#include "Block.h"

#include "GlobalDefine.h"

#include "GPULite.h"
#include "Charactors.h"

#include "Console.h"
#include "Sleep.h"

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

void BlockTRP(uint32_t x,uint32_t y)
{
    LCDRectangle(COLOR_TRP,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
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


// void BlockTRP(uint32_t x,uint32_t y)
// {
//     LCDRectangle(COLOR_TRA,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
//     return;
// }

// void BlockMAC(uint32_t x,uint32_t y,uint32_t z)
// {
//     LCDRectangle(GREEN,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
//     Arrow(x,y,z,WHITE);
//     return;
// }


void BlockDOR(uint32_t x,uint32_t y,uint32_t opensign)
{
    BlockICE(x,y);
    if(opensign>=1)//123表示开门动作，321表示关门动作，3紧闭，1大开
    {
        LCDPixelSquare(COLOR_DOR,x-BLOCK_INNE,y-BLOCK_INNE,x-BLOCK_INNE+4,y+BLOCK_INNE);
        LCDPixelSquare(COLOR_DOR,x+BLOCK_INNE-4,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
        if(opensign>=2)
        {
            LCDPixelSquare(COLOR_DOR_BOARD,x-BLOCK_INNE+4+2,y-BLOCK_INNE+4,x-BLOCK_INNE+8+2,y+BLOCK_INNE-4);
            LCDPixelSquare(COLOR_DOR_BOARD,x+BLOCK_INNE-8-2,y-BLOCK_INNE+4,x+BLOCK_INNE-4-2,y+BLOCK_INNE-4);
            LCDPixelSquare(COLOR_DOR,x-BLOCK_INNE,y-12,x-BLOCK_INNE+16,y-8);
            LCDPixelSquare(COLOR_DOR,x-BLOCK_INNE,y+8,x-BLOCK_INNE+16,y+12);
            LCDPixelSquare(COLOR_DOR,x+BLOCK_INNE-16,y-12,x+BLOCK_INNE,y-8);
            LCDPixelSquare(COLOR_DOR,x+BLOCK_INNE-16,y+8,x+BLOCK_INNE,y+12);
            if(opensign>=3)
            {
                LCDPixelSquare(COLOR_DOR_BOARD,x-BLOCK_INNE+12+2,y-BLOCK_INNE+4,x-BLOCK_INNE+16+2,y+BLOCK_INNE-4);
                LCDPixelSquare(COLOR_DOR_BOARD,x+BLOCK_INNE-16-2,y-BLOCK_INNE+4,x+BLOCK_INNE-12-2,y+BLOCK_INNE-4);
                LCDPixelSquare(COLOR_DOR,x-BLOCK_INNE+10,y-12,x,y-8);
                LCDPixelSquare(COLOR_DOR,x-BLOCK_INNE+10,y+8,x,y+12);
                LCDPixelSquare(COLOR_DOR,x,y-12,x+BLOCK_INNE-10,y-8);
                LCDPixelSquare(COLOR_DOR,x,y+8,x+BLOCK_INNE-10,y+12);
            }
        }
    }
    return;
}

void BlockTRP(uint32_t x,uint32_t y)
{
    BlockICE(x,y);
    LCDPixelSquare(COLOR_BAR,x-8,y-7,x+7,y-6);
    LCDPixelSquare(COLOR_BAR,x-8,y-5,x+7,y-5);
    LCDPixelSquare(COLOR_TRP,x-6,y-5,x+5,y-5);
    LCDPixelSquare(COLOR_BAR,x-10,y-4,x+9,y-4);
    LCDPixelSquare(COLOR_TRP,x-8,y-4,x+7,y-4);
    LCDPixelSquare(COLOR_BAR,x-14,y-3,x+10,y-3);
    LCDPixelSquare(COLOR_TRP,x-12,y-3,x+8,y-3);
    LCDPixelSquare(COLOR_BAR,x-15,y-2,x+11,y-2);
    LCDPixelSquare(COLOR_TRP,x-13,y-2,x+9,y-2);
    LCDPixelSquare(COLOR_BAR,x-17,y-1,x+12,y-1);
    LCDPixelSquare(COLOR_TRP,x-15,y-1,x+10,y-1);
    LCDPixelSquare(COLOR_BAR,x-18,y-0,x+14,y-0);
    LCDPixelSquare(COLOR_TRP,x-16,y-0,x+12,y-0);
    LCDPixelSquare(COLOR_TRP,x-15,y+1,x+15,y+1);
    LCDPixelSquare(COLOR_TRP,x-13,y+2,x+16,y+2);
    LCDPixelSquare(COLOR_TRP,x-10,y+3,x+14,y+3);
    LCDPixelSquare(COLOR_TRP,x-9,y+4,x+12,y+4);
    LCDPixelSquare(COLOR_TRP,x-8,y+5,x+9,y+5);
    LCDPixelSquare(COLOR_TRP,x-8,y+6,x+7,y+6);
    return;
}