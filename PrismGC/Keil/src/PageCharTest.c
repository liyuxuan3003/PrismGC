#include "PageCharTest.h"

#include "GlobalDefine.h"

#include "Sleep.h"
#include "Timer.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"
#include "GPIO.h"
#include "HardwareConfig.h"

#include <string.h>

uint8_t PageCharTest()
{
    uint32_t x;
    while(1)
    {
        if(KEYBOARD -> KEY == 0x0F)
            return PAGE_MAIN;

        if(SWI_7(P)==0)
        {
            BUZZER->NOTE=3;
            BUZZER->TIME=50;
        }

        x++;
        if(x>=64)
            x=0;    

        PingPong();
        LCDBackground(0xFFFFFF);
        LCDRectangle(0xFFFF00,(64-x)*64,50 ,(64-x+1)*64,50+64);    
        LCDRectangle(0x00FFFF,(64-x)*64,250,(64-x+1)*64,250+64);  
        LCDRectangle(0xFF00FF,(64-x)*64,450,(64-x+1)*64,450+64);

        for (int j=0;j<10;j++)
            for(int i=0;i<90;i++)
                LCDChar(0xFF0000,0x00FF00,' '+i,100+8*i,50+20*j,1);

        for (int i=0;i<26;i++)
            LCDChar(0x000000,0xFFFFFF,'A'+i,100+30*i,300,1);

        for (int i=0;i<26;i++)
            LCDChar(0x000000,0xFFFFFF,'A'+i,100+30*i,400,2);
    }
}