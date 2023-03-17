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

    PORTA -> O_SWI_ENA = 0x00;
    PORTA -> O_LED_ENA = 0xFF;
    PORTA -> O_SEG_ENA = 0xFF;
    PORTA -> O_SEGCS_ENA = 0xF;
    PORTA -> O_SEGCS_DAT = 0x1;

    // PORTB -> O_SWI_ENA = 0x00;
    // PORTB -> O_LED_ENA = 0xFF;

    // PORTB -> O_SWI_ENA = 0x00;
    // PORTB -> O_LED_ENA = 0xFF;
	
	while(1)
	{
        // UARTString("Hello World!\r\n");
        PORTA->O_LED_DAT=PORTA->I_SWI_DAT;
        PORTA->O_SEG_DAT=PORTA->I_SWI_DAT;
        // LED_0(V);
        Delay(TICKS);
        // LED_0(H);
        // Delay(TICKS);
        // LED_0(L);
        // Delay(TICKS);
	}
}

