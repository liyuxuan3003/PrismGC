#include "PageBlockGame.h"

#include "Sleep.h"
#include "HardwareConfig.h"
#include "UART.h"
#include "GPIO.h"
#include "Digit.h"
#include "Timer.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"

#include "GlobalDefine.h"

uint8_t PageBlockGame()
{
    uint16_t x=0;
    uint16_t x1=X1_BLOCK_PLACE;
    uint16_t x2=X2_BLOCK_PLACE;
    uint16_t y1=Y1_BLOCK_PLACE;
    uint16_t y2=Y2_BLOCK_PLACE;
    while(1)
    {
        PingPong();
        LCDBackground(0xFFFFFF);
        // BUZZER -> NOTE = x;
        // BUZZER -> TIME = 200;
        // x--;
        if(y2<=600)
        {
            LCDBackground(0xFFFFFF);
            LCDRectangle(0x000000,0,500,1024,520,128);
            LCDRectangle(0xFFFFFF,x,500,x+2*BLOCK_WIDTH,520,BLOCK_WIDTH);
            LCDRectangle(0xFF0000,x1,y1,x2,y2,BLOCK_WIDTH);
            mdelay(10);
            y1 += BLOCK_HEIGHT;
            y2 += BLOCK_HEIGHT;
            if(KEYBOARD -> KEY == 0x06)
            {
                if(x1==0)
                {
                    x1=1000;
                    x2=1020;
                }
                else
                {
                    x1 -= BLOCK_WIDTH;
                    x2 -= BLOCK_WIDTH;
                }
            }
            else if(KEYBOARD -> KEY== 0x05)
            {  
                if(x2==1020)
                {
                    x2=20;
                    x1=0;
                }
                x1 += BLOCK_WIDTH;
                x2 += BLOCK_WIDTH;  
            }
        }
        else
        {
            y1=Y1_BLOCK_PLACE;
            y2=Y2_BLOCK_PLACE;
            x += BLOCK_WIDTH;
            if(x>=1000)
            x=0;
            mdelay(100);
        }
    }
}