#include "Block.h"

#include "GPULite.h"

void BlockBorder(uint32_t x,uint32_t y)
{
    LCDRectangle(0xFFFFFF,x-BLOCK_SIZE,y-BLOCK_SIZE,x+BLOCK_SIZE,y+BLOCK_SIZE);
    return;
}

void BlockICE(uint32_t x,uint32_t y)
{
    BlockBorder(x,y);
    LCDRectangle(0xCCCCFF,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}

void BlockBAR(uint32_t x,uint32_t y)
{
    BlockBorder(x,y);
    LCDRectangle(0x000000,x-BLOCK_INNE,y-BLOCK_INNE,x+BLOCK_INNE,y+BLOCK_INNE);
    return;
}