#include "PageBlockGame.h"

#include "Sleep.h"
#include "HardwareConfig.h"
#include "UART.h"
#include "GPIO.h"
#include "Digit.h"
#include "Timer.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"

#include "GlobalDefine.h"

uint8_t PageBlockGame()
{
    uint8_t x=7;
    while(1)
    {
        PingPong();
        LCDBackground(0x00FF00);
        BUZZER -> NOTE = x;
        BUZZER -> TIME = 200;
        x--;
        if(x==0)
            return PAGE_MAIN;
        mdelay(500);
    }
}