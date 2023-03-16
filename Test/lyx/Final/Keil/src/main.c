#include <string.h>
#include <stdint.h>

#include "UART.h"

int main()
{ 
	//interrupt initial
	NVIC_CTRL_ADDR = 1;

	//UART display
	UARTString("Cortex-M0 Start up!\r\n");
	
	while(1)
	{
        UARTString("Hello World!\r\n");
        Delay(0x05f5e100);
	}
}

