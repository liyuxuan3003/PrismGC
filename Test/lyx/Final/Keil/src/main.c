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
	// NVIC_CTRL_ADDR = 1;

    GPIOA -> O_ENA = 0x3;
    GPIOB -> O_ENA = 0x3;
    GPIOC -> O_ENA = 0x3;
    GPIOD -> O_ENA = 0x3;

    GPIOA -> O_DAT = 0x2;
    GPIOB -> O_DAT = 0x2;
    GPIOC -> O_DAT = 0x2;
    GPIOD -> O_DAT = 0x2;

	//UART display
	// UARTString("Cortex-M0 Start up!\r\n");

    // PORTA -> O_SWI_ENA = 0x00;
    // PORTA -> O_LED_ENA = 0xFF;
	
    // PORTA -> O_LED_DAT = 0x55;

    // PORTB -> O_DB_ENA =0xFF;
    // PORTB -> O_DB_DAT =0x55;

    // GPIOA -> O_ENA = 0xFFF;
    // GPIOA -> O_DAT = 0x055;

    // GPIOC -> O_ENA = 0xFFF;
    // GPIOC -> O_DAT = 0x055;

    // PORTC -> O_SEG_ENA = 0xFF;
    // PORTC -> O_SEGCS_ENA = 0xF;

    // PORTC -> O_SEG_DAT = 0xFF;
    // PORTC -> O_SEGCS_DAT = 0x1;


    // PORTC -> O_DIG_ENA = 0xFFFF;
    // PORTC -> O_DIG_DOT_ENA = 0xF;
    // PORTC -> O_DIG_ENA_ENA = 0xF;
    // PORTC -> O_DIG_CRT_ENA = 0xF;

    // PORTC -> O_DIG_DAT = 0x0123;
    // PORTC -> O_DIG_DOT_DAT = 0x0;
    // PORTC -> O_DIG_ENA_DAT = 0xF;
    // PORTC -> O_DIG_CRT_DAT = 0xF;
    
	while(1)
	{
        // UARTString("Hello World!\r\n");
        // PORTA -> O_LED_DAT ++;
        // Delay(TICKS/10);
	}
}

