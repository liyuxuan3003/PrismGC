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
#include "PageEnd.h"

#include "GlobalDefine.h"

uint8_t PageBlockGame()
{
    DIG[2].DOT = 1;

    uint16_t x1=X1_BLOCK_PLACE;
    uint16_t x2=X2_BLOCK_PLACE;
    uint16_t y1=Y1_BLOCK_PLACE;
    uint16_t y2=Y2_BLOCK_PLACE;
    uint16_t Score=INIT_SCORE;
    uint16_t Health=INIT_HEALTH;
    uint16_t XPlace1=BLOCK_WIDTH*(TIMER -> TIME%10);
    uint16_t XPlace2=BLOCK_WIDTH*((TIMER -> TIME%10)+3);
    uint32_t Color=BLUE;
    uint8_t Level=1;
    while(1) 
    {
        if(KEYBOARD -> KEY == 0x0F)
            return PAGE_MAIN;

        PingPong();
        LCDBackground(0xFFFFFF);
        // BUZZER -> NOTE = x;
        // BUZZER -> TIME = 200;
        // x--;
        if(y2<=600)
        {
            LCDBackground(WHITE);
            LCDRectangle(BLACK,0,500,1024,520);
            LCDRectangle(WHITE,XPlace1,500,XPlace1+2*BLOCK_WIDTH,520);
            if(Level == 2)
            {
                LCDRectangle(BLACK,0,300,1024,320);
                LCDRectangle(WHITE,XPlace2,300,XPlace2+2*BLOCK_WIDTH,320);
            }
            LCDRectangle(Color,x1,y1,x2,y2);
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
            if(y1 == 300 && Level == 2)
            {
                Color = RED;
                if(XPlace2<=x1&&x1<=XPlace2+BLOCK_WIDTH)
                {
                    BUZZER -> NOTE = 7;
                    BUZZER -> TIME = 50;
                    Score += UP_SCORE;
                    Health = Health;
                    Color = YELLOW;
                }
                else
                {
                    BUZZER -> NOTE = 1;
                    BUZZER -> TIME = 200;
                    Score = Score;
                    Health -= DOWN_HEALTH;
                }
                if(Health == 0)
                {
                    DIG[3].COD = Health;
                    return PAGE_MAIN;
                }
            }
            if(y1 == 500)
            {
                if(XPlace1<=x1&&x1<=XPlace1+BLOCK_WIDTH)
                {
                    BUZZER -> NOTE = 7;
                    BUZZER -> TIME = 50;
                    Score += UP_SCORE;
                    Health = Health;
                    Color = GREEN;
                }
                else
                {
                    BUZZER -> NOTE = 1;
                    BUZZER -> TIME = 200;
                    Score = Score;
                    Health -= DOWN_HEALTH;
                    Color = RED;
                }
                if(Health == 0)
                {
                    DIG[3].COD = Health;
                    return PAGE_MAIN;
                }
            }
            y1 += BLOCK_HEIGHT;
            y2 += BLOCK_HEIGHT;
        }
        else
        {
            y1=Y1_BLOCK_PLACE;
            y2=Y2_BLOCK_PLACE;
            XPlace1 += BLOCK_WIDTH*(TIMER -> TIME%10);
            XPlace2 += BLOCK_WIDTH*((TIMER -> TIME%10));
            if(XPlace1>=1000)
            XPlace1=0;
            if(XPlace2>=1000)
            XPlace2=BLOCK_WIDTH*3;
            mdelay(100);
            Color = BLUE;
        }
        DIG[0].COD = Score%10;
        DIG[1].COD = Score/10;
        DIG[2].COD = Level;
        DIG[3].COD = Health;
        if(Health == 0)
            return PAGE_MAIN;
        if(Score == 25)
        {
            Level ++;
            // Score = 0;
        }
        if(Level == 3)
            Level = 2;
    }
}