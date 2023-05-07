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

int main() 
{     

	//interrupt initial
	NVIC_CTRL_ADDR = 1;

	//UART display
	//UARTString("Cortex-M0 Start up!\r\n");

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
            //RamWrite(0,0,0x0000ff,8,2);
            
            LCDBackground(0xFFFFFF);
            //LCDRectangle(0x0000FF,0,450,8,450,2);
            
            LCDRectangle(0x000000,16,16,16+256,16+256,16);
            LCDRectangle(0xFFFF00,0,550,1024,555,64);
            LCDRectangle(0xFF0000,(64-x)*1,50 ,(64-x)*1+1,50+64 ,1);    
            LCDRectangle(0x00FF00,(64-x)*2,250,(64-x)*2+7,250+64,7);  
            LCDRectangle(0x0000FF,(64-x)*1,450,(64-x)*1+64,450+64,16);  
            
        }
        else
            mdelay(200);
	}
}

