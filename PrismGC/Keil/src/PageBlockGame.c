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

    uint16_t x1=X1_BLOCK_PLACE;
    uint16_t x2=X2_BLOCK_PLACE;
    uint16_t y1=Y1_BLOCK_PLACE;
    uint16_t y2=Y2_BLOCK_PLACE;
    uint16_t Score=INIT_SCORE;
    uint16_t Health=INIT_HEALTH;
    uint16_t XPlace=BLOCK_WIDTH*(TIMER -> TIME%10);
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
            LCDRectangle(0xFFFFFF,XPlace,500,XPlace+2*BLOCK_WIDTH,520);
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
                if(XPlace<=x1&&x1<=XPlace+BLOCK_WIDTH)
                {
                    BUZZER -> NOTE = 1;
                    BUZZER -> TIME = 200;
                    Score += UP_SCORE;
                    Health = Health;
                }
                else
                {
                    BUZZER -> NOTE = 7;
                    BUZZER -> TIME = 200;
                    Score = Score;
                    Health -= DOWN_HEALTH;
                }
            }
            y1 += BLOCK_HEIGHT;
            y2 += BLOCK_HEIGHT;
        }
        else
        {
            y1=Y1_BLOCK_PLACE;
            y2=Y2_BLOCK_PLACE;
            XPlace += BLOCK_WIDTH*(TIMER -> TIME%10);
            if(XPlace>=1000)
            XPlace=0;
            mdelay(100);
        }
        DIG[0].COD = Score%10;
        DIG[1].COD = Score/10;
        DIG[3].COD = Health;
        if(Health == 0)
        return PAGE_MAIN;
    }
}