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
static uint8_t levelSTEP;

void ConfigEnd(uint8_t _levelID)
{
    levelID=_levelID;
    return;
}

void ConfigEndStep(uint8_t _levelSTEP)
{
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
        LCDPrintf(BLUE,BISQUE,840,200,5,"%d",levelSTEP);
        LCDPrintf(BLACK,CHOCOLATE,250,450,2,"PRESS KEY_C TO CHOOSE GAME LEVEL");

        if(KEYBOARD -> KEY != 0xFF)
        {
            switch (KEYBOARD -> KEY)
            {
                case 0x00: return PAGE_MAIN; break;
                case 0x06: return PAGE_MENU; break;
            }
        }

        while(TIMER -> TIME < nowTime + FRAME);
    }
    
}