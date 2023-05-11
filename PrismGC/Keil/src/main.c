#include <string.h>
#include <stdint.h>
#include <stdlib.h>

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
#include "LoadPage.h"
#include "ScoreDetermination.h"
#include "HealthDetermination.h"


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
        DIG[2].ENA = 0;
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
    int  x1=400, y1=0, x2=416, y2=16;
    uint16_t t=0;
    uint16_t health=3;
    uint16_t poh=5;
    uint16_t score=0;
    uint8_t j=0,k=0;
    int X1[20];
    int X2[20];
    int Y1[20];
    int Y2[20];
    for(int i=0;i<=4;i++)
    {
        X1[i]=0;
        X2[i]=0;
        Y1[i]=0;
        Y2[i]=0;
    };
    X1[0]=64;
    X2[0]=80;
    Y1[0]=64;
    Y2[0]=80;
    while(1)
    {
        PingPong();
        if(SWI_6(P)&&health>0)
        {
            LCDBackground(0xFFFFFF);
            LCDRectangle(0x000000,0,400,1024,416,16);
            LCDRectangle(0xFFFFFF,16*poh,400,16*(poh+1),416,16);
            LCDRectangle(0xFF0000,x1,y1,x2,y2,16);
            y1=AutoY(y1);
            y2 += V_SPEED;
            x1=MoveX(x1);
            x2 += H_SPEED;
            if(y1==400)
            {
                score=ScoreDetermination(x1,poh,score);
                health=HealthDetermination(x1,poh,health);
                poh=poh+5;
            }
            if(poh>63)
            poh=1;
            DIG[0].COD = score%10;
            DIG[1].COD = score/10;
            DIG[3].COD = health;
            DIG[2].DOT = 1;
        }
        /*else if(SWI_7(P))
        {
            LCDBackground(0xFFFFFF);
            LCDRectangle(0x000000,256,256,272,272,16);
            if(KEYBOARD -> KEY == 0x01)
            {
                Y2[0]=Y1[0];
                Y1[0]=Y1[0]+16;
                
            }
            else if(KEYBOARD -> KEY == 0x09)
            {
                Y1[0]=Y2[0];
                Y2[0]=Y2[0]-16;
            }
            else if(KEYBOARD -> KEY == 0x06)
            {
                X2[0]=X1[0];
                X1[0]=X1[0]-16;
            }
            else if(KEYBOARD -> KEY == 0x04)
            {
                X1[0]=X2[0];
                X2[0]=X2[0]+16;
            };
            if(X1[0]==256&&Y1[0]==256)
            {
                j++;
            }
            for(int i=0;i<=j;i++)
            {
                X1[i+1]=X1[i];
                Y1[i+1]=Y1[i]-16;
                X2[i+1]=X2[i];
                Y2[i+1]=Y2[i]-16;
                LCDRectangle(0xFF0000,X1[i],Y1[i],X2[i],Y2[i],16);
                Y1[i]=Y1[i]+16;
                Y2[i]=Y2[i]+16;
            }
            if(Y1[0]>=584)
            {
                Y1[0]=0+16*j;
                Y2[0]=16+16*j;
            };
        }*/
        else
        {
            uint16_t x;
            LoadPage(x);
            if(!SWI_6(P))
            {
                x1=400;
                y1=0;
                x2=416;
                y2=16;
                t=0;
                health=3;
                poh=5;
                score=0;
            }
        }
    }
}