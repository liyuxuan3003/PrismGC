#include <string.h>
#include <stdint.h>

#include "BitOperate.h"

#include "Sleep.h"

#include "Interrupt.h"
#include "HardwareConfig.h"
#include "UART.h"
#include "GPIO.h"
#include "Digit.h"
//#include "SDRAM.h"
//#include "HDMI.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"
#include "GameFunc.h"


int main() 
{     

	//interrupt initial
	NVIC_CTRL_ADDR = 1;

	//UART display
	UARTString("Cortex-M0 Start up!\r\n");

    //PORTA IO STATUS
    PORTA -> O_SWI_ENA = 0x00;
    PORTA -> O_LED_ENA = 0xFF;

    //PORTA INIT
    PORTA -> O_LED_DAT = 0x00;

    DIG_CRTL = 0xF;
    for(unsigned int i=0;i<4;i++)
    {
        DIG[i].ENA = 1;
    }

    WaitRamReady();
    LCDBackground(0xFFFFFF);

    /*int x=0;

	while(1)
	{
        for(unsigned int i=0;i<4;i++)
            DIG[i].COD ++;
        PORTA -> O_LED_DAT = PORTA -> I_SWI_DAT;

        if(SWI_7(P))
        {
            BUZZER -> NOTE ++;
            BUZZER -> TIME = 200;
        }

        if(SWI_6(P))
        {
            x++;
            if(x>=64)
                x=0;
            PingPong();
            LCDBackground(0x00FFFF);
            LCDRectangle(0x000000,16,16,16+256,16+256,16);
            LCDRectangle(0xFFFF00,0,550,1024,555,64);
            LCDRectangle(0xFF0000,(64-x)*16,50 ,(64-x)*16+64,50+64 ,16);
            if (KEYBOARD -> KEY == 0x0A)
                LCDRectangle(0x00FF00,(64-x)*16,250,(64-x)*16+64,250+64,16);  
            LCDRectangle(0x0000FF,(64-x)*16,450,(64-x)*16+64,450+64,16);  
        }
        else
            mdelay(200);
	}*/
    uint16_t x1=400, y1=0, x2=416, y2=16;
    uint16_t t=0;
    uint16_t xue=3;
    uint16_t l=5;
    uint16_t Score=0;
    while(1)
    {
        PingPong();
        if(SWI_6(P)&&xue>0)
        {
            LCDBackground(0xFFFFFF);
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
            };
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
        }
        else
        {
            uint16_t x;
            LCDBackground(0xFFFFFF);
            x++;
            if(x>=64)
            x=0;
            LCDRectangle(0xFF0000,(64-x)*16,50 ,(64-x)*16+64,50+64 ,16);
            LCDRectangle(0x00FF00,(64-x)*16,250,(64-x)*16+64,250+64,16);  
            LCDRectangle(0x0000FF,(64-x)*16,450,(64-x)*16+64,450+64,16);
            if(!SWI_6(P))
            {
                x1=400;
                y1=0;
                x2=416;
                y2=16;
                t=0;
                xue=3;
                l=5;
                Score=0;
            }
        }
    }
}