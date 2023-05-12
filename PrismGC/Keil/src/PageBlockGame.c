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
    DIG[2].ENA = 0;
    DIG[2].DOT = 1;

    uint16_t x=0;
    uint16_t x1=X1_BLOCK_PLACE;
    uint16_t x2=X2_BLOCK_PLACE;
    uint16_t y1=Y1_BLOCK_PLACE;
    uint16_t y2=Y2_BLOCK_PLACE;
    uint16_t Score=Init_Score;
    uint16_t Health=Init_Health;
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
            LCDRectangle(0x000000,0,500,1024,520);
            LCDRectangle(0xFFFFFF,x,500,x+2*BLOCK_WIDTH,520);
            LCDRectangle(0xFF0000,x1,y1,x2,y2);
            mdelay(10);
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
            if(y1==500)
            {
                if(x<=x1&&x1<=x+BLOCK_WIDTH)
                {
                    BUZZER -> NOTE = 3;
                    BUZZER -> TIME = 200;
                    Score +=Up_Score;
                    Health = Health;
                }
                else
                {
                    BUZZER -> NOTE = 6;
                    BUZZER -> TIME = 200;
                    Score = Score;
                    Health -= Down_Health;
                }
            }
            y1 += BLOCK_HEIGHT;
            y2 += BLOCK_HEIGHT;
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
        DIG[0].COD = Score%10;
        DIG[1].COD = Score/10;
        DIG[3].COD = Health;
        if(Health == 0)
        return PAGE_MAIN;
    }
}