#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

#include "BitOperate.h"

#include "Sleep.h"

#include "Interrupt.h"
#include "HardwareConfig.h"
#include "UART.h"
#include "GPIO.h"
#include "Digit.h"
#include "Timer.h"
//#include "SDRAM.h"
//#include "HDMI.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"

#include "PageMain.h"
#include "PageBlockGame.h"
#include "GlobalDefine.h"

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

    int x=0;

	while(1)
	{
        for(unsigned int i=0;i<4;i++)
            DIG[i].COD ++;
        // PORTA -> O_LED_DAT = PORTA -> I_SWI_DAT;
        PORTA -> O_LED_DAT = (TIMER -> TIME) % 256;

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
            
            LCDBackground(0xFFFFFF);
            
            LCDRectangle(0x000000,16,16,16+256,16+256);
            LCDRectangle(0xFFFF00,0,550,1024,555);
            LCDRectangle(0xFF00FF,0,345,512,350);
            LCDRectangle(0xFF00FF,0,350,563,360);
            LCDRectangle(0xFF0000,(64-x)*1,50 ,(64-x)*1+1,50+64);    
            LCDRectangle(0x00FF00,(64-x)*2,250,(64-x)*2+7,250+64);  
            LCDRectangle(0x0000FF,(64-x)*1,450,(64-x)*1+64,450+64);  
        }
        else
            mdelay(200);
	}
}
