#include "PageMain.h"

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
#include "Nunchuck.h"
#include "Block.h"
#include "Sleep.h"

#include <string.h>

static void BlockICEMain(uint32_t x,uint32_t y)
{
    LCDRectangle(COLOR_GRO,x-32,y-32,x+32,y+32);
    LCDRectangle(COLOR_ICE,x-BLOCK_INNE-8,y-BLOCK_INNE-8,x+BLOCK_INNE+8,y+BLOCK_INNE+8);
    return;
}

uint8_t PageMain()
{
    uint32_t nowTime;
    uint16_t x=0;
    BUZZER -> NOTE = 0;
    while(1)
    {
        nowTime = TIMER -> TIME;

        if(NunchuckKey()=='C')
            return PAGE_MENU;

        switch (KEYBOARD -> KEY)
        {
            case 0x00: return PAGE_BLOCK_GAME; break;
            case 0x01: return PAGE_CHAR_TEST; break;
            case 0x02: return PAGE_MAZE_GAME; break;
            case 0x03: return PAGE_MENU; break;
            case 0x0C: return PAGE_I2C_TEST; break;
            case 0x0F: break;
            default: break;
        }
            
        if(SWI_7(P)==0)
            BGMPageMain();

        x++;
        if(x>=96)
            x=0;    
        PingPong();
        LCDBackground(0xCCEEFF);
        for (uint32_t i=0;i<=15;i++)
        {
            for (uint32_t j=0;j<=4;j++)
            {
                BlockICEMain((96-x)*96+64*i,350+64*j);
            }
        }
        MainCharactor(150,280,6);
        AppleGray(1024-150,280,4);
        LCDPrintf(0x000000,0xCCEEFF,512-strlen("Click any key to start")/2*8,200,1,"Click any key to start");//22
        LCDPrintf(0x000000,0xCCEEFF,512-strlen("Invincible Slime's Adventure")/2*16,100,2,"Invincible Slime's Adventure");//28
        while(TIMER -> TIME < nowTime + FRAME) ;
    }
}