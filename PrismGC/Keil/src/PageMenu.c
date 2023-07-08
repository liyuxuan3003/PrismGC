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

#include <string.h>

static const uint8_t menuType[]={1,1,1,1,1,2,2,2,2,2,3,3,3,3,3};

void BlockICEMenu(uint32_t x,uint32_t y,int type)
{
    uint32_t a;
    switch(type)
    {
        case 1:a=COLOR_ICE;break;
        case 2:a=COLOR_TRA;break;
        case 3:a=COLOR_DEL;break;
        case 4:a=COLOR_BAR;break;
    }
    LCDRectangle(COLOR_GRO,x-32,y-32,x+32,y+32);
    LCDRectangle(a,x-BLOCK_INNE-8,y-BLOCK_INNE-8,x+BLOCK_INNE+8,y+BLOCK_INNE+8);
    return;
}

void LevelMenu (uint32_t x,uint32_t y,int type,int num)
{
    BlockICEMenu(x,y,type);
    // if (num < 10)
    //     LCDPrintf(0x000000,0xFFFFFF,x-16,y,2,"0%d",num);
    // else
    LCDPrintf(0x000000,0xFFFFFF,x-16,y,2,"%02d",num);
    return;
}

uint8_t PageMenu()
{
    while(1)
    {
        if(KEYBOARD->KEY == 0x0F)
            return PAGE_MAIN;

        PingPong();
        LCDBackground(0xCCEEFF);
        for(uint32_t i=0;i<3;i++)
        {
            for(uint32_t j=0;j<=4;j++)
                LevelMenu(64*3+32+128*j,102+166*i,menuType[5*i+j],5*i+j+1);
        }
    }
}