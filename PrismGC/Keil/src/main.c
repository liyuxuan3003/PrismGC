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

#include "GlobalDef.h"
#include "PageMain.h"
#include "PageBlockGame.h"

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

    uint8_t status = PAGE_MAIN;
    mdelay(1000);

    while(1)
    {
        PORTA -> O_LED_DAT = 0xFF;
        mdelay(1000);
        if(status == PAGE_MAIN)
            status = PageMain();
        else if(status == PAGE_BLOCK_GAME)
            status = PageBlockGame();
        else
            status = PAGE_MAIN;
        mdelay(100);
    }
}