#include "PageMain.h"

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

uint8_t PageMain()
{
    uint8_t x=1;
    while(1)
    {
        PingPong();
        LCDBackground(0xFF0000);
        BUZZER -> NOTE = x;
        BUZZER -> TIME = 200;
        x++;
        if(x==8)
            return PAGE_BLOCK_GAME;
        mdelay(500);
    }
}