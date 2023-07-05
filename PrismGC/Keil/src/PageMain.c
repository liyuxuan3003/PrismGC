#include "PageMain.h"

#include "Sleep.h"
#include "HardwareConfig.h"
#include "UART.h"
#include "GPIO.h"
#include "Digit.h"
#include "Timer.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"
#include "BGM.h"

#include "GlobalDefine.h"
#include "console.h"
#include <string.h>

uint8_t PageMain()
{
    uint32_t nowTime;
    uint16_t x=0;
    BUZZER -> NOTE = 0;
    while(1)
    {
        /*
        char buf[64];
        int ret=conReadData(buf,sizeof(buf));
        if(ret>0)
        {
            printf("**%s**",buf);
            if(strcmp(buf,"help")==0)
                printf("help test\n");
        }
        */
        nowTime = TIMER -> TIME;
        if(SWI_7(P)==0)
            BGMPageMain();
        if(KEYBOARD -> KEY != 0xFF)
            return PAGE_BLOCK_GAME;
        x++;
        if(x>=64)
            x=0;    
        PingPong();
        LCDBackground(0xFFFFFF);
        LCDRectangle(0xFF0000,(64-x)*64,50 ,(64-x+1)*64,50+64);    
        LCDRectangle(0x00FF00,(64-x)*64,250,(64-x+1)*64,250+64);  
        LCDRectangle(0x0000FF,(64-x)*64,450,(64-x+1)*64,450+64);

        uint32_t colors[8]={0xff,0xffffff,0xffffff,0xffffff,0xffffff,0xffffff,0xff,0xff};
        
        for(int i=0;i<50;i++)
        {
            LCDPixels(colors,100,500+i,8);
            //colors[i]=0xffffff;
        }

        LCDChar(100,560,'B');
        LCDChar(120,560,' ');
        LCDChar(140,560,'B');
        LCDChar(160,560,'S');
        LCDChar(180,560,'B');

        LCDChar(510,250,'B');
        LCDChar(254,250,'B');

        for (int j=0;j<10;j++)
            for(int i=0;i<90;i++)
                LCDChar(100+8*i,50+20*j,' '+i);
        
        // while(TIMER -> TIME < nowTime + FRAME) ;
        // mdelay(FRAME);
    }
}