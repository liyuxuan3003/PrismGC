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
    uint32_t nowTime;
    uint16_t x=0;
    BUZZER -> NOTE = 0;
    while(1)
    {
        nowTime = TIMER -> TIME;
        PingPong();
        LCDBackground(0xFFFFFF);
        // BUZZER -> NOTE ++;
        // BUZZER -> TIME = FRAME;
        if(KEYBOARD -> KEY != 0xFF)
            return PAGE_BLOCK_GAME;
            x++;
        if(x>=64)
            x=0;    
        LCDRectangle(0xFF0000,(64-x)*64,50 ,(64-x+1)*64,50+64 ,16);    
        LCDRectangle(0x00FF00,(64-x)*64,250,(64-x+1)*64,250+64,16);  
        LCDRectangle(0x0000FF,(64-x)*64,450,(64-x+1)*64,450+64,16);  

        // while(TIMER -> TIME < nowTime + FRAME) ;
        mdelay(FRAME);
    }
}