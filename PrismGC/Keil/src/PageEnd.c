#include "PageEnd.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "GetKey.h"
#include "GPULite.h"
#include "KeyBoard.h"
#include "HardwareConfig.h"
#include "Buzzer.h"

#include "Block.h"
#include "BlockMap.h"
#include "Charactors.h"
#include "PageMenu.h"
#include "BGM.h"

static uint8_t levelID;
static uint8_t appleNumber;
static uint8_t levelStep;
static uint8_t isWin;

void ConfigEnd(uint8_t _levelID,uint8_t _appleNumber,uint8_t _levelStep,uint8_t _isWin)
{
    levelID=_levelID;
    appleNumber=_appleNumber;
    levelStep=_levelStep;
    isWin=_isWin;
    return;
}

uint8_t PageEnd()
{
    uint8_t colorChange=1;
    uint32_t colora;//闪动字体颜色
    uint32_t colorb;//闪动字体背景色
    uint32_t colord;//闪动字体颜色2
    uint32_t colorc;//背景色
    uint16_t time=0;
    while(1)
    {
        uint32_t nowTime = TIMER -> TIME;
        PingPong();
        // LCDBackground(CHOCOLATE);
        // LCDRectangle(SADDLEBROWN,80,40,944,350);
        // LCDRectangle(BISQUE,90,50,934,340);
        // LCDPrintf(BLACK,BISQUE,110,70,2,"Level %02d",levelID);
        
        BuzzerConfig();

        ConfigBgmNote(isWin,&time);

        if(isWin)
        {
            colora=GOLD;
            colorb=BISQUE;
            colord=OLIVEDRAB;
            colorc=CHOCOLATE;
            LCDBackground(colorc);
            LCDRectangle(SADDLEBROWN,80,40,944,350);
            LCDRectangle(colorb,90,50,934,340);
            LCDPrintf(RED,colorb,200,130,8,"YOU WIN!");
            for(uint32_t i=0;i<APPLE_MAX;i++)
            {
                if(i+1<=appleNumber)
                    Apple((i+1)*(H_DISP/4),450,8);
                else
                    AppleGray((i+1)*(H_DISP/4),450,8);
            }
            BGMPageWin();
        }
        
        else
        {
            colora=GREYBLUE;
            colorb=WHI;
            colord=GREYBLUE;
            colorc=BLUE;
            LCDBackground(colorc);
            LCDRectangle(colora,80,40,944,350);
            LCDRectangle(colorb,90,50,934,340);
            LCDPrintf(BLUE,colorb,200,130,8,"YOU FAIL");
            for(uint32_t i=0;i<CHARA_MAX;i++)
                MainCharactorGray((i+1)*(H_DISP/4),450,8);
            BGMPageFail();
        }

        LCDPrintf(BLACK,colorb,110,70,2,"Level %02d",levelID);

        switch(colorChange)
        {
            case 1:
            {
                LCDPrintf(colord,colorb,795,80,3,"TOTAL");
                LCDPrintf(colord,colorb,810,120,3,"STEP");
                colorChange=0;
                break;
            }
            case 0:
            {
                LCDPrintf(colora,colorb,795,80,3,"TOTAL");
                LCDPrintf(colora,colorb,810,120,3,"STEP");
                colorChange=1;
                break;
            }
        }

        if(levelStep<10)
            LCDPrintf(colora,colorb,840,200,5,"%d",levelStep);
        else
            LCDPrintf(colora,colorb,820,200,5,"%d",levelStep);
             
        
        LCDPrintf(colorb,colorc,275,550,2,"PRESS KEY_C TO CHOOSE GAME LEVEL");

        switch(GetKey(1))
        {
            case KEY_E: return PAGE_MAIN; break;
            case KEY_C: return PAGE_MENU; break;
            default: break;
        }

        LCDRectangle(colorc,0,0,16,V_DISP);

        // LCDPrintf(colora,colorb,100,500,2,"%d",time);

        while(TIMER -> TIME < nowTime + time);
    }
    
}