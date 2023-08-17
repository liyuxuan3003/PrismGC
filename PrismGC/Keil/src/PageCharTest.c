#include "PageCharTest.h"

#include "GlobalDefine.h"

#include "Sleep.h"
#include "Timer.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"
#include "GPIO.h"
#include "HardwareConfig.h"
#include "Charactors.h"
#include "Block.h"

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

        // for(int j=0;j<10;j++)
        //     for(int i=0;i<90;i++)
        //         LCDChar(0xFF0000,0x00FF00,100+8*i,50+20*j,1,' '+i);

        for(int i=0;i<26;i++)
            LCDChar(0x000000,0xFFFFFF,100+30*i,250,1,'A'+i);

        for(int i=0;i<26;i++)
            LCDChar(0x000000,0xFFFFFF,100+30*i,300,2,'A'+i);

        for(int i=0;i<26;i++)
            LCDChar(0x000000,0xFFFFFF,100+30*i,350,3,'A'+i);

        uint32_t colors[24]=
        {
            0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000,
            0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000,
            0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000
        };

        //LCDPixels的len需满足5<=len<=16
        for(int i=5;i<16;i++)
            LCDPixels(colors,128,400+i,i+1);

        MainCharactor(400,450,6);
        Apple(500,450,1);

        // for(int i=0;i<8;i++)
        // {
        //     LCDPixels(colors,200,400+i,i+1);
        // }

        LCDPrintf(0x000000,0xFFFFFF,200,500,1,"Zhang Yan %d",123,59.5);
        LCDPrintf(0x000000,0xFFFFFF,200,550,2,"Zhang Yan %d",123,59.5);

        LCDRectangle(0xFF0000,200,100,300,150);
        LCDRectangle(0x00FF00,200,200,256,250);
        LCDRectangle(0x0000FF,256,200,300,250);

        LCDRectangle(0xFF0000,450,100,600,150);
        LCDRectangle(0x00FF00,450,200,512,250);
        LCDRectangle(0x0000FF,512,200,516,250);

        MainCharactor(253,450,2);
        MainCharactor(253,200,2);
        MainCharactor(253,300,2);

        LCDRectangle(0xFF0000,800,400,801,420);
        LCDRectangle(0xFF0000,800,420,802,440);
        LCDRectangle(0xFF0000,800,440,803,460);
        LCDRectangle(0xFF0000,800,460,804,480);
        LCDRectangle(0xFF0000,800,480,805,500);

        BlockDOR(500,500,1);
        BlockDOR(500,400,2);
        BlockDOR(500,300,3);

        LCDCircle(0xFF0000,100,300,32,2);
        LCDCircle(0xFF0000,200,300,32,4);
        LCDCircle(0xFF0000,300,300,32,8);

        // for(int i=0;i<4;i++)
        // {
        //     LCDRectangle(0x000201*i,0,i,i,i);
        // }

        // Arrow(800,400,2,0x000000);
    }
}