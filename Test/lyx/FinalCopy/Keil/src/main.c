#include <string.h>
#include <stdint.h>

#include "BitOperate.h"

#include "Sleep.h"

#include "Interrupt.h"
#include "HardwareConfig.h"
#include "UART.h"
#include "GPIO.h"
#include "HDMI.h"
#include "Digit.h"

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
    for(int i=0;i<4;i++)
    {
        DIG[i].ENA = 1;
    }

	while(1)
	{
        for(int i=0;i<4;i++)
            DIG[i].COD ++;
        PORTA -> O_LED_DAT = PORTA -> I_SWI_DAT;
        uint8_t a = PORTA -> O_LED_DAT;
        UARTWrite(a);
        HDMI -> PIXEL = HDMI -> X_POS + 0xFF * HDMI -> Y_POS;
        Delay(TICKS/5);
	}
}

