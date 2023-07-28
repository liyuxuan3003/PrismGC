#include "PageEnd.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "GetKey.h"
#include "GPULite.h"
#include "KeyBoard.h"

#include "Block.h"
#include "BlockMap.h"
#include "Charactors.h"
#include "PageMenu.h"

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
    while(1)
    {
        uint32_t nowTime = TIMER -> TIME;
        PingPong();
        LCDBackground(CHOCOLATE);
        LCDRectangle(SADDLEBROWN,80,40,944,350);
        LCDRectangle(BISQUE,90,50,934,340);
        LCDPrintf(BLACK,BISQUE,110,70,2,"Level %02d",levelID);

        if(isWin)
        {

            LCDPrintf(RED,BISQUE,200,130,8,"YOU WIN!");
            for(uint32_t i=0;i<APPLE_MAX;i++)
            {
                if(i+1<=appleNumber)
                    Apple((i+1)*(H_DISP/4),450,8);
                else
                    AppleGray((i+1)*(H_DISP/4),450,8);
            }

        }
        
        else
        {
            LCDPrintf(RED,BISQUE,200,130,8,"YOU FAIL");
            for(uint32_t i=0;i<CHARA_MAX;i++)
                MainCharactorGray((i+1)*(H_DISP/4),450,8);
        }
        

        switch(colorChange)
        {
            case 1:
            {
                LCDPrintf(OLIVEDRAB,BISQUE,795,80,3,"TOTAL");
                LCDPrintf(OLIVEDRAB,BISQUE,810,120,3,"STEP");
                colorChange=0;
                break;
            }
            case 0:
            {
                LCDPrintf(GOLD,BISQUE,795,80,3,"TOTAL");
                LCDPrintf(GOLD,BISQUE,810,120,3,"STEP");
                colorChange=1;
                break;
            }
        }

        if(levelStep<10)
            LCDPrintf(ORANGE,BISQUE,840,200,5,"%d",levelStep);
        else
            LCDPrintf(ORANGE,BISQUE,820,200,5,"%d",levelStep);
            
        
        LCDPrintf(BLACK,CHOCOLATE,275,550,2,"PRESS KEY_C TO CHOOSE GAME LEVEL");

        switch(GetKey())
        {
            case KEY_E: return PAGE_MAIN; break;
            case KEY_C: return PAGE_MENU; break;
            default: break;
        }

        LCDRectangle(CHOCOLATE,0,0,16,V_DISP);

        while(TIMER -> TIME < nowTime + FRAME);
    }
    
}