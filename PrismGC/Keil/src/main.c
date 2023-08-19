#include <string.h>
#include <stdint.h>
#include <stdlib.h>

#include "Console.h"

#include "BitOperate.h"

#include "Sleep.h"

#include "Interrupt.h"
#include "HardwareConfig.h"
#include "UART.h"
#include "GPIO.h"
#include "Digit.h"
#include "Timer.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"
#include "Nunchuck.h"

#include "PageMain.h"
#include "PageMenu.h"
#include "PageBlockGame.h"
#include "PageI2CTest.h"
#include "PageCharTest.h"
#include "PageMazeGame.h"
#include "PageEnd.h"

#include "GlobalDefine.h"

int main() 
{     
	//interrupt initial
	NVIC_CTRL_ADDR = 1;

	//UART display
	UARTString("Cortex-M0 Start up!\r\n");
	printf("Cortex-M0 Version 0.1\n");

    //PORTA IO STATUS
    PORTA -> O_SWI_ENA = 0x00;
    PORTA -> O_LED_ENA = 0xFF;

    DIG_CRTL = 0xF;
    for(uint8_t i=0;i<4;i++)
        DIG[i].ENA = 0;

    //Nunchuck init
    NunchuckInit();

    WaitRamReady();
    LCDBackground(0xFFFFFF);

    uint8_t status=PAGE_MAIN;
    while(1)
    {
        switch(status)
        {
            case PAGE_MAIN:         status=PageMain();      break;
            case PAGE_BLOCK_GAME:   status=PageBlockGame(); break;
            case PAGE_MAZE_GAME:    mdelay(250); status=PageMazeGame();  break;
			case PAGE_MENU:         mdelay(250); status=PageMenu(); break;
            case PAGE_CHAR_TEST:    status=PageCharTest();  break;
            case PAGE_I2C_TEST:     status=PageI2CTest();   break;
            case PAGE_END:          status=PageEnd();       break;
            default: status=PageMain(); break;
        }
    }
}
