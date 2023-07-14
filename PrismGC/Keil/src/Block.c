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
    Arrow(x,y,z);
    return;
}

void BlockMAC(uint32_t x,uint32_t y,uint32_t z)
{
    LCDRectangle(COLOR_MAC,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    Arrow(x,y,z);
    return;
}