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

    while(!HDMI -> SYS_VAILD) ;

    HDMI -> X_POS = 0;
    HDMI -> Y_POS = 0;
    HDMI -> PIXEL = 0xFFFFFF;
    HDMI -> LEN = 1024 * 600;
    HDMI -> SYS_WR_LEN = 256;
    HDMI -> ENABLE = 1;
    Delay(TICKS);
    HDMI -> ENABLE = 0;

    Delay(TICKS*5);

    HDMI -> X_POS = 20;
    HDMI -> Y_POS = 20;
    HDMI -> PIXEL = 0xFF0000;
    HDMI -> LEN = 500;
    HDMI -> SYS_WR_LEN = 1;
    HDMI -> ENABLE = 1;
    Delay(TICKS);
    HDMI -> ENABLE = 0;

    uint32_t pat=0x1;
	while(1)
	{
        PORTA -> O_LED_DAT = PORTA -> I_SWI_DAT;
        PORTC -> O_DIG_DAT --;
        Delay(TICKS/5000);
	}
}

