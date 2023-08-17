#include "Charactors.h"
#include "Charactors.h"
#include "Charactors.h"
#include "GPULite.h"
#include "GlobalDefine.h"
#include "Block.h"

static const uint32_t chtMainLen = 12;
static const uint32_t chtMainColor[] = {M_WHI_C,M_BLK_C,M_BLU_C,M_LBU_C,M_DBU_C};
static const uint32_t chtMainGrayColor[] = {M_WHI_C,M_BLK_C,M_BLU_G,M_LBU_G,M_DBU_G};
static const CharactorLine chtMain[]=
{
    {4,8, {M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK}},
    {2,12,{M_BLK,M_BLK,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_BLK,M_BLK}},
    {1,14,{M_BLK,M_LBU,M_LBU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_LBU,M_LBU,M_BLK}},
    {1,14,{M_BLK,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLK}},
    {1,14,{M_BLK,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_BLU,M_BLU,M_BLU,M_WHI,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_WHI,M_BLU,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_LBU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_LBU,M_BLK}},
    {0,16,{M_BLK,M_BLU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_BLU,M_BLU,M_BLU,M_DBU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_DBU,M_BLU,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_DBU,M_DBU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_DBU,M_BLK}},
    {1,14,{M_BLK,M_BLK,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_BLK,M_BLK}},
    {3,10,{M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK}}
};

static const uint32_t appleLen = 16;
static const uint32_t appleColor[] = {A_WHI_C,A_BLK_C,A_RED_C,A_DKR_C,A_BRO_C};
static const uint32_t appleGrayColor[] = {A_WHI_G,A_BLK_G,A_RED_G,A_DKR_G,A_BRO_G};
static const CharactorLine apple[]=
{
    {8,1, {A_BRO}},
    {8,1, {A_BRO}},
    {8,1, {A_BRO}},
    {3,10,{A_BLK,A_BLK,A_BLK,A_BLK,A_BLK,A_BRO,A_BLK,A_BLK,A_BLK,A_BLK}},
    {2,12,{A_BLK,A_RED,A_RED,A_RED,A_RED,A_RED,A_BRO,A_RED,A_RED,A_RED,A_RED,A_BLK}},
    {1,14,{A_BLK,A_RED,A_RED,A_RED,A_RED,A_BRO,A_RED,A_BRO,A_RED,A_BRO,A_RED,A_RED,A_RED,A_BLK}},
    {1,15,{A_BLK,A_RED,A_RED,A_RED,A_RED,A_RED,A_BRO,A_BRO,A_BRO,A_RED,A_RED,A_RED,A_RED,A_RED,A_BLK}},
    {0,16,{A_BLK,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_WHI,A_RED,A_BLK}},
    {0,16,{A_BLK,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_WHI,A_RED,A_BLK}},
    {0,16,{A_BLK,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_BLK}},
    {0,16,{A_BLK,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_WHI,A_RED,A_BLK}},
    {0,16,{A_BLK,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_BLK}},
    {0,16,{A_BLK,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_BLK}},
    {1,14,{A_BLK,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_BLK}},
    {2,12,{A_BLK,A_DKR,A_DKR,A_DKR,A_DKR,A_DKR,A_RED,A_RED,A_DKR,A_DKR,A_DKR,A_BLK}},
    {4,8, {A_BLK,A_BLK,A_BLK,A_BLK,A_BLK,A_BLK,A_BLK,A_BLK}}
};

static void Charactor(uint32_t xcn,uint32_t ycn,const CharactorLine* cht,uint32_t chtlen,const uint32_t *chtColor,uint8_t scale)
{
    uint32_t pixels[CHT_SCALE_MAX*PIXELS_MAX]={0};
    for(uint32_t i=0;i<chtlen;i++)
    {
        for(uint32_t j=0;j<cht[i].len;j++)
            for(uint32_t s=0;s<scale;s++)
                pixels[j*scale+s]=chtColor[cht[i].line[j]];   //预设一列s倍长度的彩线
        for(uint32_t j=0;j<scale;j++)               //绘制scale行
            for(uint32_t s=0;s<scale;s++)           //每行绘制scale个len的长度
                LCDPixels(pixels+cht[i].len*s,xcn+(cht[i].xoffset)*scale+cht[i].len*s,ycn+i*scale+j,cht[i].len);//
    }  
    return;
}

void MainCharactor(uint32_t x,uint32_t y,uint8_t scale)
{
    uint32_t xcn=x-8*scale;
    uint32_t ycn=y-5*scale;
    Charactor(xcn,ycn,chtMain,chtMainLen,chtMainColor,scale);
    return;
}

void MainCharactorGray(uint32_t x,uint32_t y,uint8_t scale)
{
    uint32_t xcn=x-8*scale;
    uint32_t ycn=y-5*scale;
    Charactor(xcn,ycn,chtMain,chtMainLen,chtMainGrayColor,scale);
    return;
}

void Apple (uint32_t x,uint32_t y,uint8_t scale)
{
    uint32_t xcn=x-8*scale;
    uint32_t ycn=y-8*scale;
    Charactor(xcn,ycn,apple,appleLen,appleColor,scale);
    return;
}

void AppleGray (uint32_t x,uint32_t y,uint8_t scale)
{
    uint32_t xcn=x-8*scale;
    uint32_t ycn=y-8*scale;
    Charactor(xcn,ycn,apple,appleLen,appleGrayColor,scale);
    return;
}

void Arrow(uint32_t x,uint32_t y,uint8_t z,uint32_t color)
{
    switch (z)
    {
        case 1: //上
        {
            LCDRectangle(color,x-ARROW_WID/2,y,x+ARROW_WID/2,y+BLOCK_INNE-ARROW_BOR);
            for(uint32_t i=0;i<ARROW_LEN/2;i+=4)
                LCDRectangle(color,x-ARROW_LEN/2+i,y-i-4,x+ARROW_LEN/2-i,y-i);
            break;
        } 
        case 2: //下
        {
            LCDRectangle(color,x-ARROW_WID/2,y-BLOCK_INNE+ARROW_BOR,x+ARROW_WID/2,y);
            for(uint32_t i=0;i<ARROW_LEN/2;i+=4)
                LCDRectangle(color,x-ARROW_LEN/2+i,y+i,x+ARROW_LEN/2-i,y+i+4);
            break;
        } 
        case 3: //左
        {
            LCDRectangle(color,x,y-ARROW_WID/2,x+BLOCK_INNE-ARROW_BOR,y+ARROW_WID/2);
            for(uint32_t i=0;i<ARROW_LEN/2;i+=6)
                LCDRectangle(color,x-i-6,y-ARROW_LEN/2+i,x-i,y+ARROW_LEN/2-i);
            break;
        } 
        case 4: //右
        {
            LCDRectangle(color,x-BLOCK_INNE+ARROW_BOR,y-ARROW_WID/2,x,y+ARROW_WID/2);
            for(uint32_t i=0;i<ARROW_LEN/2;i+=6)
                LCDRectangle(color,x+i,y-ARROW_LEN/2+i,x+i+6,y+ARROW_LEN/2-i);
            break;
        } 
        default: break;
    }
}

void Cloud(uint32_t x,uint32_t y,int z,uint32_t size)
{
    LCDCircle(0xFFFFFF,x-size*1.2,y,size,2);
    LCDCircle(0xFFFFFF,x+size*1.2,y,size,2);
    LCDCircle(0xFFFFFF,x+z*0.4*size,y-size*1.2,size*1.3,3);
    LCDRectangle(0xFFFFFF,x-size*1.2,y-size*0.2,x+size*1.2,y+size);
}