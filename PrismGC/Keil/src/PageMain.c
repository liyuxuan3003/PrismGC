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
#include "Console.h"
#include "GetKey.h"

#include <string.h>

static int BordenCheck(int a)
{
    if(a<=0)
        a=0;
    if(a>=1024)
        a=1024;
    return a;
}

static void BlockICEMain(uint32_t x,uint32_t y)
{
    int a,b,c,d;
    a=x-32;
    b=x+32;
    c=y-32;
    d=y+32;
    a=BordenCheck(a);
    b=BordenCheck(b);
    c=BordenCheck(c);
    d=BordenCheck(d);
    LCDRectangle(COLOR_GRO,a,c,b,d);
    a=x-BLOCK_INNE-8;
    b=x+BLOCK_INNE+8;
    c=y-BLOCK_INNE-8;
    d=y+BLOCK_INNE+8;
    a=BordenCheck(a);
    b=BordenCheck(b);
    c=BordenCheck(c);
    d=BordenCheck(d);
    LCDRectangle(COLOR_ICE,a,c,b,d);
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

        if(GetKey(1)==KEY_C)
            return PAGE_MENU;

        if(KEYBOARD -> KEY != 0xFF)
        {
            if(KEYBOARD -> KEY != 0x0F)
                return PAGE_MENU;
        }

        // switch (KEYBOARD -> KEY)
        // {
        //     case 0x00: return PAGE_BLOCK_GAME; break;
        //     case 0x01: return PAGE_CHAR_TEST; break;
        //     case 0x02: return PAGE_MAZE_GAME; break;
        //     case 0x03: return PAGE_MENU; break;
        //     case 0x0C: return PAGE_I2C_TEST; break;
        //     case 0x0F: break;
        //     default: break;
        // }
        
        BuzzerConfig(SWI_6(P),SWI_7(P));

        BGMPageMain();

        x++;
        if(x>=4)
            x=0;

        PingPong();
        LCDBackground(MAIN_BG_COL);
        for (uint32_t i=0;i<=17;i++)
        {
            for (uint32_t j=0;j<=4;j++)
            {
                BlockICEMain((-x)*MOVESPEED+64*i,380+64*j);
            }
        }
        MainCharactor(150,291,8);
        Apple(1024-150,300,6);

        const char title[]="Invincible Slime's Adventure";
        const char titleSub[]="PRESS KEY_C TO START";

        LCDPrintf(WHITE,MAIN_BG_COL,512-strlen(titleSub)/2*2*8,230,2,titleSub);
        LCDPrintf(WHITE,MAIN_BG_COL,512-strlen(title)/2*4*8,100,4,title);
        while(TIMER -> TIME < nowTime + FRAME) ;
    }
}