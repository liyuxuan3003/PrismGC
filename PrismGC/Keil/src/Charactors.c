#include "Charactors.h"
#include "GPULite.h"

static const uint32_t chtMainLen = 12;
static const uint32_t appleLen   = 16;
static const CharactorLine chtMain[]=
{
    {4,8, {M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK}},
    {2,12,{M_BLK,M_BLK,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_LBU,M_BLK,M_BLK}},
    {1,14,{M_BLK,M_LBU,M_LBU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_LBU,M_LBU,M_BLK}},
    {1,14,{M_BLK,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLK}},
    {1,14,{M_BLK,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_BLU,M_BLU,M_BLU,M_WHI,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_WHI,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_LBU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_LBU,M_BLK}},
    {0,16,{M_BLK,M_BLU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLK,M_BLU,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_BLU,M_BLU,M_BLU,M_DBU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_DBU,M_BLU,M_BLU,M_BLU,M_BLK}},
    {0,16,{M_BLK,M_DBU,M_DBU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_BLU,M_DBU,M_BLK}},
    {1,14,{M_BLK,M_BLK,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_DBU,M_BLK,M_BLK}},
    {3,10,{M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK,M_BLK}}
};

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
    {1,13,{A_BLK,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_RED,A_BLK}},
    {2,11,{A_BLK,A_DKR,A_DKR,A_DKR,A_DKR,A_DKR,A_RED,A_DKR,A_DKR,A_DKR,A_BLK}},
    {4,8, {A_BLK,A_BLK,A_BLK,A_BLK,A_BLK,A_BLK,A_BLK,A_BLK}}
};

// static const CharactorLine appleGray[]=
// {
//     {8,1, {A_DKG}},
//     {8,1, {A_DKG}},
//     {8,1, {A_DKG}},
//     {3,10,{A_BLK,A_BLK,A_BLK,A_BLK,A_BLK,A_DKG,A_BLK,A_BLK,A_BLK,A_BLK}},
//     {2,12,{A_BLK,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_DKG,A_GRE,A_GRE,A_GRE,A_GRE,A_BLK}},
//     {1,14,{A_BLK,A_GRE,A_GRE,A_GRE,A_GRE,A_DKG,A_GRE,A_DKG,A_GRE,A_DKG,A_GRE,A_GRE,A_GRE,A_BLK}},
//     {1,15,{A_BLK,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_DKG,A_DKG,A_DKG,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_BLK}},
//     {0,16,{A_BLK,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_WHI,A_GRE,A_BLK}},
//     {0,16,{A_BLK,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_WHI,A_GRE,A_BLK}},
//     {0,16,{A_BLK,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_BLK}},
//     {0,16,{A_BLK,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_WHI,A_GRE,A_BLK}},
//     {0,16,{A_BLK,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_BLK}},
//     {0,16,{A_BLK,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_BLK}},
//     {1,13,{A_BLK,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_GRE,A_BLK}},
//     {2,11,{A_BLK,A_DKG,A_DKG,A_DKG,A_DKG,A_DKG,A_GRE,A_DKG,A_DKG,A_DKG,A_BLK}},
//     {4,8, {A_BLK,A_BLK,A_BLK,A_BLK,A_BLK,A_BLK,A_BLK,A_BLK}}
// };

 static uint32_t ColorTra(uint8_t colorTem,int grey)//(const CharactorLine* cht,uint8_t grey)
 {
        switch (colorTem)//(cht[i].line[j])
        {
            case 0   :return C_BLU;break;
            case 1   :return C_WHI;break;
            case 2   :return C_LBU;break;
            case 3   :return C_DBU;break;
            case 4   :return C_BLK;break;
            case 5   :
            {
                if (grey)
                return C_DKG;
                else
                return C_BRO;
                break;
            }
            case 6   :
            {
                if (grey)
                return C_GRE;
                else
                return C_RED;
                break;
            }
            case 7   :
            {
                if (grey)
                return C_DKG;
                else
                return C_DKR;
                break;
            }
            case 8   :return C_WHI;break;
            case 9   :return C_BLK;break;
            // case 10  :return C_GRE;break;
            // case 11  :return C_DKG;break;
            default:break;
        }
 }

static void Charactor(uint32_t xcn,uint32_t ycn,const CharactorLine* cht,uint32_t chtlen,uint8_t scale,int grey)
{
    uint32_t pixels[CHT_MAIN_SCALE_MAX*PIXELS_MAX]={0};
    for(uint32_t i=0;i<chtlen;i++)
    {
        for(uint32_t j=0;j<cht[i].len;j++)
            for(uint32_t s=0;s<scale;s++)
                pixels[j*scale+s]=ColorTra(cht[i].line[j],grey);   //预设一列s倍长度的彩线
        for(uint32_t j=0;j<scale;j++)               //绘制scale行
            for(uint32_t s=0;s<scale;s++)           //每行绘制scale个len的长度
                LCDPixels(pixels+cht[i].len*s,xcn+(cht[i].xoffset)*scale+cht[i].len*s,ycn+i*scale+j,cht[i].len);//
    }  
    return;
}

// static void Charactor(uint32_t xcn,uint32_t ycn,uint32_t colorTem,uint32_t chtlen,uint8_t scale)
// {
//     uint32_t pixels[CHT_MAIN_SCALE_MAX*PIXELS_MAX]={0};
//     for(uint32_t i=0;i<chtlen;i++)
//     {
//         for(uint32_t j=0;j<cht[i].len;j++)
//             for(uint32_t s=0;s<scale;s++)
//                 pixels[j*scale+s]=colorTem;   //预设一列s倍长度的彩线
//         for(uint32_t j=0;j<scale;j++)               //绘制scale行
//             for(uint32_t s=0;s<scale;s++)           //每行绘制scale个len的长度
//                 LCDPixels(pixels+cht[i].len*s,xcn+(cht[i].xoffset)*scale+cht[i].len*s,ycn+i*scale+j,cht[i].len);//
//     }  
//     return;
// }



void MainCharactor (uint32_t x,uint32_t y,uint8_t scale)
{
    uint32_t xcn=x-8*scale;
    uint32_t ycn=y-5*scale;
    Charactor(xcn,ycn,chtMain,chtMainLen,scale,0);
    return;
}

void Apple (uint32_t x,uint32_t y,uint8_t scale)
{
    uint32_t xcn=x-8*scale;
    uint32_t ycn=y-8*scale;
    Charactor(xcn,ycn,apple,appleLen,scale,0);
    return;
}

void AppleGray (uint32_t x,uint32_t y,uint8_t scale)
{
    uint32_t xcn=x-8*scale;
    uint32_t ycn=y-8*scale;
    Charactor(xcn,ycn,apple,appleLen,scale,1);
    return;
}