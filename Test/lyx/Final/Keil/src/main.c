#include <string.h>
#include <stdint.h>

#include "BitOperate.h"

#include "Sleep.h"

#include "Interrupt.h"
#include "HardwareConfig.h"
#include "UART.h"
#include "GPIO.h"

int main() 
{ 
	//interrupt initial
	NVIC_CTRL_ADDR = 1;

	//UART display
	UARTString("Cortex-M0 Start up!\r\n");

    //PORTA -> O_SWI_EN = 0x00;
    //PORTA -> O_LED_EN = 0xFF;

    //PORTA -> O_LED_DATA = 0x55;
    GPIOA->O_EN=0x700;
    //GPIOA->O_DATA=0x01555500;
    /*
    char c = PORTA -> O_LED_DATA;

    UARTWrite('*');
    UARTWrite(c);
    UARTWrite('*');

    c = PORTA->I_LED_DATA;

    UARTWrite('*');
    UARTWrite(c);
    UARTWrite('*');

    c = PORTA->I_SWI_DATA;

    UARTWrite('*');
    UARTWrite(c);
    UARTWrite('*');
*/
    SWI_0(I);
    LED_0(O);
    LED_1(O);

    LED_0(H);
	
	while(1)
	{
        UARTString("Hello World!\r\n");
        LED_0(H);
        Delay(TICKS);
        LED_0(L);
        Delay(TICKS);
	}
}
