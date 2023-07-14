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