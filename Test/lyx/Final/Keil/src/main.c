#include <string.h>
#include <stdint.h>

#include "BitOperate.h"

#include "Sleep.h"

#include "Interrupt.h"
#include "HardwareConfig.h"
#include "UART.h"
#include "GPIO.h"
#include "HDMI.h"

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

    //PORTC IO STATUS
    PORTC -> O_DIG_ENA = 0xFFFF;
    PORTC -> O_DIG_DOT_ENA = 0xF;
    PORTC -> O_DIG_ENA_ENA = 0xF;
    PORTC -> O_DIG_CRT_ENA = 0xF;

    //PORTC INIT
    PORTC -> O_DIG_DAT = 0x0000;
    PORTC -> O_DIG_DOT_DAT = 0x4;
    PORTC -> O_DIG_ENA_DAT = 0xF;
    PORTC -> O_DIG_CRT_DAT = 0xF;

    int cnt=0;
    int pat=0x1;

	while(1)
	{
        if(cnt>=1000)
        {
            cnt=0;
            pat++;
            if(pat==0x0C)
                pat=0x01;
        }
        PORTA -> O_LED_DAT = PORTA -> I_SWI_DAT;
        PORTC -> O_DIG_DAT --;
        HDMI -> HDMI_DATA = pat;
        cnt++;
        Delay(TICKS/5000);
	}
}

