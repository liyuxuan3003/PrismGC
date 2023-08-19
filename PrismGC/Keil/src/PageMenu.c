#include "PageMenu.h"

#include "GlobalDefine.h"

#include "Sleep.h"
#include "GPIO.h"
#include "HardwareConfig.h"
#include "Timer.h"
#include "GetKey.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "BGM.h"
#include "Charactors.h"
#include "Block.h"
#include "PageMazeGame.h"
#include "PageEnd.h"
#include "Digit.h"

#include <string.h>

#define LINE1 1
#define LINE2 2
#define LINE3 3
#define LINE4 4

#define LEVEL_BLOCK_SIZE 32
#define LEVEL_BLOCK_INN_SIZE 28
#define HIGHLIGHT_SIZE 40

static const uint8_t menuType[]=
{
    LINE1,LINE1,LINE1,LINE1,
    LINE2,LINE2,LINE2,LINE2,
    LINE3,LINE3,LINE3,LINE3,
    LINE4,LINE4,LINE4,LINE4
};

static void LevelMenu(uint32_t x,uint32_t y,uint8_t type,uint8_t num)
{
    uint32_t a;
    switch(type)
    {
        case LINE1:a=0xDEFFF0;break;
        case LINE2:a=0xDBDCFF;break;
        case LINE3:a=0xFFF4B7;break;
        case LINE4:a=0xFFE0DB;break;
    }

    LCDRectangle(0xFFFFFF,
        x-LEVEL_BLOCK_SIZE,
        y-LEVEL_BLOCK_SIZE,
        x+LEVEL_BLOCK_SIZE,
        y+LEVEL_BLOCK_SIZE);

    LCDRectangle(a,
        x-LEVEL_BLOCK_INN_SIZE,
        y-LEVEL_BLOCK_INN_SIZE,
        x+LEVEL_BLOCK_INN_SIZE,
        y+LEVEL_BLOCK_INN_SIZE);

    LCDPrintf(0xFFFFFF-a,a,x-16,y-16,2,"%02d",num);

    return;
}

static void HighLight(uint32_t x,uint32_t y)
{
    LCDRectangle(ORANGE,x-HIGHLIGHT_SIZE,y-HIGHLIGHT_SIZE,x+HIGHLIGHT_SIZE,y+HIGHLIGHT_SIZE);
    return;
}

static uint8_t LevelID(int32_t m,int32_t n,uint8_t pageNum)
{
    return LEVELNUM_PER_PAGE*(pageNum-1)+JMAX*m+n+1;
}

static int32_t mSave=0;
static int32_t nSave=0;
static uint8_t pageNumSave=1;

uint8_t PageMenu()
{
    uint32_t nowTime;

    // 将第m行第n列的关卡高亮
    int32_t m=mSave;
    int32_t n=nSave;
    uint8_t pageNum=pageNumSave;

    for(uint8_t i=0;i<4;i++)
    {
        DIG[i].ENA = 1;
        DIG[i].DOT = 0;
    }

    DIG[3].ENA=0;
    DIG[2].ENA=0;
    DIG[2].DOT=1;

    while(1)
    {
        nowTime = TIMER -> TIME;

        BuzzerConfig();

        DIG[3].COD=(LevelID(m,n,pageNum)/10)%10;
        DIG[1].COD=(LevelID(m,n,pageNum)/10)%10;
        DIG[2].COD=(LevelID(m,n,pageNum)/1)%10;
        DIG[0].COD=(LevelID(m,n,pageNum)/1)%10;

        switch(GetKey(1))
        {
            case KEY_E: 
            {
                mSave=m;
                nSave=n;
                pageNumSave=pageNum;
                return PAGE_MAIN;
            }
            case KEY_R:
            {
                n++;
                if(n>=JMAX)
                {
                    n=0;m++;
                    if(m>=IMAX)
                    {
                        m=0;pageNum++;
                        if (pageNum>PAGEMAX)
                        {
                            pageNum--;
                            n=JMAX-1;
                            m=IMAX-1;
                        }
                    }
                }
                break;
            } 
            case KEY_L:
            {
                n--;
                if(n<0)
                {
                    n=JMAX-1;m--;
                    if(m<0)
                    {
                        m=IMAX-1;pageNum--;
                        if (pageNum<1)
                        {
                            pageNum++;
                            n=0;
                            m=0;
                        }   
                    }
                }
                break;
            } 
            case KEY_U: 
            {
                m--;
                if(m<0)
                {
                    m=IMAX-1;pageNum--;
                    if (pageNum<1)
                    {
                        pageNum++;
                        m=0;
                    }
                }
                break;
            } 
            case KEY_D: 
            {
                m++;
                if(m>=IMAX)
                {
                    m=0;
                    pageNum++;
                    if (pageNum>PAGEMAX)
                    {
                        pageNum--;
                        m=IMAX-1;
                    }
                }
                break;
            } 
            case KEY_C: 
            {
                BuzzerOutput(4,300);
                mSave=m;
                nSave=n;
                pageNumSave=pageNum;
                ConfigMazeGame(LevelID(m,n,pageNum));
                return PAGE_MAZE_GAME;
                break;
            } 
            default:  break;
        }
        PingPong();
        LCDBackground(MENU_BG_COL);
        HighLight(MENUXBORD+LEVEL_BLOCK_SIZE+LEVEL_BLOCK_SIZE*2*(1+INTERVALXBLOCK)*n,
                    MENUYBORD+LEVEL_BLOCK_SIZE+(LEVEL_BLOCK_SIZE*2+INTERVALYBLOCK)*m);
        for(uint32_t i=0;i<IMAX;i++)
        {
            for(uint32_t j=0;j<JMAX;j++)
                LevelMenu(
                    MENUXBORD+LEVEL_BLOCK_SIZE+LEVEL_BLOCK_SIZE*2*(1+INTERVALXBLOCK)*j,
                    MENUYBORD+LEVEL_BLOCK_SIZE+(LEVEL_BLOCK_SIZE*2+INTERVALYBLOCK)*i,
                    menuType[4*i+j],
                    LevelID(i,j,pageNum));
        }
        const char menuTitle[]="Choose Your Level";

        LCDPrintf(WHITE,MENU_BG_COL,512-strlen(menuTitle)/2*24,MENUYBORD/2-24,3,menuTitle);
        LCDPrintf(WHITE,MENU_BG_COL,512-5/2*16,600-(MENUYBORD/2)-8,2,"%02d/%02d",pageNum,PAGEMAX);
        while(TIMER -> TIME < nowTime + FRAME);
    }
}