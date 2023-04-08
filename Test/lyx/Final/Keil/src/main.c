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

    HDMI -> LCD_CMD = 0xFF000000;
    HDMI -> LCD_CMD = 0x00110011;
    HDMI -> LCD_CMD = 0x00FF0000;

    uint32_t pat=0x1;
	while(1)
	{
        PORTA -> O_LED_DAT = PORTA -> I_SWI_DAT;
        PORTC -> O_DIG_DAT --;
        pat = PORTA -> I_SWI_DAT;
        pat >>= 4;
        // HDMI -> LCD_CMD = pat;
        Delay(TICKS/5000);
	}
}

