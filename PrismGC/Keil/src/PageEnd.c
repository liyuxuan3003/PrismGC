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
static uint8_t levelSTEP;

void ConfigEnd(uint8_t _levelID,uint8_t _appleNumber,uint8_t _levelSTEP)
{
    levelID=_levelID;
    appleNumber=_appleNumber;
    levelSTEP=_levelSTEP;
    return;
}

uint8_t PageEnd()
{
    uint8_t colorChange=1;
    while(1)
    {
        uint32_t nowTime = TIMER -> TIME;
        PingPong();
        LCDRectangle(CHOCOLATE,0,0,1024,600);
        LCDRectangle(SADDLEBROWN,80,40,944,350);
        LCDRectangle(BISQUE,90,50,934,340);
        LCDPrintf(BLACK,BISQUE,110,70,2,"Level:%d",levelID);
        LCDPrintf(RED,BISQUE,200,130,8,"YOU WIN!");
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

        if(levelSTEP<10)
            LCDPrintf(ORANGE,BISQUE,840,200,5,"%d",levelSTEP);
        else
            LCDPrintf(ORANGE,BISQUE,820,200,5,"%d",levelSTEP);

        switch (appleNumber)
        {
            case 1:
            {
                Apple(256,450,8);
                break;
            }
            case 2:
            {
                Apple(256,450,8);
                Apple(512,450,8);
                break;
            }
            case 3:
            {
                Apple(256,450,8);
                Apple(512,450,8);
                Apple(768,450,8);
                break;
            }
            default:break;
        }
        
        LCDPrintf(BLACK,CHOCOLATE,275,550,2,"PRESS KEY_C TO CHOOSE GAME LEVEL");

        switch(GetKey())
        {
            case KEY_E: return PAGE_MAIN; break;
            case KEY_C: return PAGE_MENU; break;
            default: break;
        }

        while(TIMER -> TIME < nowTime + FRAME);
    }
    
}