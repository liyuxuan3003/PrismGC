#include "PageMenu.h"

#include "GlobalDefine.h"

#include "Sleep.h"
#include "GPIO.h"
#include "HardwareConfig.h"
#include "Timer.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"
#include "BGM.h"
#include "Charactors.h"
#include "Block.h"
#include "PageMazeGame.h"

#include <string.h>

#define LINE1 1
#define LINE2 2
#define LINE3 3

#define LEVEL_BLOCK_SIZE 32
#define LEVEL_BLOCK_INN_SIZE 28
#define HIGHLIGHT_SIZE 40

static const uint8_t menuType[]=
{
    LINE1,LINE1,LINE1,LINE1,LINE1,
    LINE2,LINE2,LINE2,LINE2,LINE2,
    LINE3,LINE3,LINE3,LINE3,LINE3
};

// void BlockICEMenu(uint32_t x,uint32_t y,int type)
// {
//     uint32_t a;
//     switch(type)
//     {
//         case LINE1:a=COLOR_ICE;break;
//         case LINE2:a=COLOR_TRA;break;
//         case LINE3:a=COLOR_DEL;break;
//     }
//     LCDRectangle(0xFFFFFF,x-LEVEL_BLOCK_SIZE,y-LEVEL_BLOCK_SIZE,x+LEVEL_BLOCK_SIZE,y+LEVEL_BLOCK_SIZE);
//     LCDRectangle(a,x-LEVEL_BLOCK_INN_SIZE,y-LEVEL_BLOCK_INN_SIZE,x+LEVEL_BLOCK_INN_SIZE,y+LEVEL_BLOCK_INN_SIZE);
//     return;
// }

static void LevelMenu(uint32_t x,uint32_t y,uint8_t type,uint8_t num)
{
    uint32_t a;
    switch(type)
    {
        case LINE1:a=COLOR_ICE;break;
        case LINE2:a=COLOR_TRA;break;
        case LINE3:a=COLOR_DEL;break;
    }
    LCDRectangle(0xFFFFFF,x-LEVEL_BLOCK_SIZE,y-LEVEL_BLOCK_SIZE,x+LEVEL_BLOCK_SIZE,y+LEVEL_BLOCK_SIZE);
    LCDRectangle(a,x-LEVEL_BLOCK_INN_SIZE,y-LEVEL_BLOCK_INN_SIZE,x+LEVEL_BLOCK_INN_SIZE,y+LEVEL_BLOCK_INN_SIZE);
    LCDPrintf(0x000000,0xFFFFFF,x-16,y-16,2,"%02d",num);
    return;
}

void HighLight(uint32_t x,uint32_t y)
{
    LCDRectangle(ORANGE,x-HIGHLIGHT_SIZE,y-HIGHLIGHT_SIZE,x+HIGHLIGHT_SIZE,y+HIGHLIGHT_SIZE);
    return;
}

uint8_t PageMenu()
{
    int32_t m=0,n=0,flagChoose=1,pageNum=1;//将第m行第n列的关卡高亮
    while(1)
    {
        if(KEYBOARD->KEY == 0x0F)
            return PAGE_MAIN;
        if(flagChoose)
        {
            switch (KEYBOARD->KEY)
            {
                case 0x05:
                {
                    n++;
                    if(n>4)
                    {
                        n=0;m++;
                        if(m>2)
                        {
                            m=0;pageNum++;
                            if (pageNum>PAGEMAX)
                            {
                                pageNum--;
                                n=4;
                                m=2;
                            }
                        }
                    }
                } break;
                case 0x07:
                {
                    n--;
                    if(n<0)
                    {
                        n=4;m--;
                        if(m<0)
                            m=2;pageNum--;
                            if (pageNum<1)
                            {
                                pageNum++;
                                n=0;
                                m=0;
                            }
                        // n=0;
                    }
                } break;
                case 0x0A: 
                {
                    m--;
                    if(m<0)
                    {
                        m=2;pageNum--;
                        if (pageNum<1)
                            {
                                pageNum++;
                                m=0;
                            }
                    }
                        // m=0;
                } break;
                case 0x02: 
                {
                    m++;
                    if(m>2)
                    {
                        m=0;
                        pageNum++;
                        if (pageNum>PAGEMAX)
                        {
                            pageNum--;
                            m=2;
                        }
                    }
                } break;
                case 0x06: 
                {
                    flagChoose=0; 
                } break;
                default:  break;
            }
        }
        PingPong();
        LCDBackground(0xCCEEFF);
        HighLight(64*3+32+128*n,102+166*m);
        for(uint32_t i=0;i<3;i++)
        {
            for(uint32_t j=0;j<=4;j++)
                LevelMenu(64*3+32+128*j,102+166*i,menuType[5*i+j],5*i+j+1+15*pageNum-15);
        }
    }
}