#include "Block.h"

#include "GlobalDefine.h"

#include "GPULite.h"
#include "Charactors.h"

void BlockICE(uint32_t x,uint32_t y)
{
    LCDRectangle(COLOR_ICE,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}

void BlockBAR(uint32_t x,uint32_t y)
{
    // LCDRectangle(COLOR_BAR,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}

void BlockEND(uint32_t x,uint32_t y)
{
    LCDRectangle(0x00FF00,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}

void BlockTRP(uint32_t x,uint32_t y)
{
    LCDRectangle(COLOR_TRA,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}

void BlockDIR(uint32_t x,uint32_t y,uint32_t z)
{
    LCDRectangle(COLOR_DIR,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    Arrow(x,y,z,0x000000);
    return;
}

void BlockMAC(uint32_t x,uint32_t y,uint32_t z)
{
    LCDRectangle(COLOR_MAC,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    Arrow(x,y,z,COLOR_MAC_ARR);
    return;
}

void BlockGRA(uint32_t x,uint32_t y,uint8_t hit)
{
    LCDRectangle(COLOR_GRA_BUT,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    LCDRectangle(COLOR_GRA,x-BLOCK_INNE+BLOCK_BORD,y-BLOCK_INNE+BLOCK_BORD,x+BLOCK_INNE-BLOCK_BORD,y+BLOCK_INNE-BLOCK_BORD);
    if(hit)
    {
       LCDSquare(COLOR_GRA_BUT,x+2,y-BLOCK_INNE+BLOCK_BORD,x+6,y-BLOCK_INNE+BLOCK_BORD+20); 
       LCDSquare(COLOR_GRA_BUT,x+6,y-6,x+BLOCK_INNE-BLOCK_BORD,y-2);
       LCDSquare(COLOR_GRA_BUT,x,y+4,x+4,y+8);
       LCDSquare(COLOR_GRA_BUT,x-2,y+8,x+2,y+BLOCK_INNE-BLOCK_BORD);
       LCDSquare(COLOR_GRA_BUT,x-8,y+8,x-2,y+12);
       LCDSquare(COLOR_GRA_BUT,x-12,y+6,x-6,y+10);
       LCDSquare(COLOR_GRA_BUT,x-BLOCK_INNE+BLOCK_BORD,y+4,x-12,y+8);
    }
}