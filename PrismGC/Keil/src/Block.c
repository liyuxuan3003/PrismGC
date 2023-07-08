#include "Block.h"

#include "GPULite.h"

void BlockBorder(uint32_t x,uint32_t y)
{
    LCDRectangle(COLOR_BOR,x-BLOCK_SIZE,y-BLOCK_SIZE,x+BLOCK_SIZE,y+BLOCK_SIZE);
    return;
}

void BlockICE(uint32_t x,uint32_t y)
{
    BlockBorder(x,y);
    LCDRectangle(COLOR_ICE,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}

void BlockBAR(uint32_t x,uint32_t y)
{
    BlockBorder(x,y);
    LCDRectangle(COLOR_BAR,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}


void BlockEND(uint32_t x,uint32_t y)
{
    BlockBorder(x,y);
    LCDRectangle(0x00FF00,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}

void BlockTRP(uint32_t x,uint32_t y)
{
    BlockBorder(x,y);
    LCDRectangle(0xFFCC00,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}