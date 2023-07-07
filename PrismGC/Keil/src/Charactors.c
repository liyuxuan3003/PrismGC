#include "Charactors.h"
#include "GPULite.h"

static const uint32_t chtMainLen = 12;
static const CharactorLine chtMain[]=
{
    {4,9, {M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK}},
    {2,13,{M_BLK,M_BLK,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_BLK,M_BLK}},
    {1,15,{M_BLK,M_LBU,M_LBU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_LBU,M_LBU,M_BLK}},
    {1,15,{M_BLK,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLK}},
    {1,15,{M_BLK,M_BLU,M_BLU,M_WHI,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_WHI,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_BLU,M_BLU,M_WHI,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_WHI,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_LBU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_LBU,M_BLK}},
    {0,16,{M_BLK,M_BLU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_BLU,M_BLU,M_BLU,M_DBU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_DBU,M_BLU,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_DBU,M_DBU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_DBU,M_BLK}},
    {0,15,{M_BLK,M_BLK,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_BLK,M_BLK}},
    {0,11,{M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK}}
};

static void Charactor(uint32_t xcn,uint32_t ycn,CharactorLine* cht,uint32_t chtlen)
{
    for(uint32_t i=0;i<chtlen;i++)
        LCDPixels(cht[i].line,xcn+cht[i].xoffset,ycn+i,cht[i].len);
    return;
}

void MainCharactor (uint32_t x,uint32_t y)
{
    uint32_t xcn=x-8;
    uint32_t ycn=y-2;
    Charactor(xcn,ycn,chtMain,chtMainLen);
    LCDPixel(M_DBU,x-10,y+2);
    LCDPixel(M_DBU,x+11,y+2);
    LCDPixel(M_DBU,x-13,y+2);
    LCDPixel(M_DBU,x+13,y+3);
    LCDPixel(M_DBU,x-12,y+5);
    LCDPixel(M_DBU,x+11,y+5);
    return;
}