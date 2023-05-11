#include "PageMain.h"

#include "Sleep.h"

#include "HardwareConfig.h"
#include "Digit.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"
#include "GameFunc.h"

uint8_t PageBlockGame()
{
    uint16_t xue=3;
    uint16_t l=5;
    uint16_t Score=0;
    int  x1=400, y1=0, x2=416, y2=16;
    while(1)
    {
        PingPong();
        LCDRectangle(0x000000,0,400,1024,416,16);
        LCDRectangle(0xFFFFFF,16*l,400,16*(l+1),416,16);
        LCDRectangle(0xFF0000,x1,y1,x2,y2,16);
        y1=y1+16;
        y2=y2+16;
        x1=MoveX(x1);
        x2=x1+16;
        if(y1>=584)
        {
            y1=0;
            y2=16;
        }
        if(y1==400)
        {
            if(x1==16*l)
            {
                xue=xue;
                Score=Score+5;
                BUZZER -> NOTE ++;
                BUZZER -> TIME = 200;
            }
            else
            {
                xue=xue-1;
            }
            l=l+5;
        }
        if(l>63)
            l=1;
        DIG[0].COD = Score%10;
        DIG[1].COD = Score/10;
        DIG[3].COD = xue;
        if(xue==0)
            return 0;
    }
}