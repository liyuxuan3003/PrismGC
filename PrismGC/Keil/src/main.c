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

#include "PageBlockGame.h"
#include "PageMain.h"

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

    uint8_t status=1;
    uint8_t temp=0;

    while(1)
    {
        if(status==0) 
        {
            UARTString("PageMain\r\n");
            temp=PageMain();
        }
        else if(status==1) 
        {
            UARTString("PageBlockGame\r\n");
            temp=PageBlockGame();
        }
        else 
        {
            UARTString("Wrong\r\n");
            temp=0;
        }
        status=temp;
        mdelay(2000);
    }
}