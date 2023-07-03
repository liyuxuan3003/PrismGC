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
#include "BGM.h"

#include "GlobalDefine.h"

uint8_t PageMain()
{
    uint32_t nowTime;
    uint16_t x=0;
    BUZZER -> NOTE = 0;
    while(1)
    {
        nowTime = TIMER -> TIME;
        if(SWI_7(P)==0)
            BGMPageMain();
        if(KEYBOARD -> KEY != 0xFF)
            return PAGE_I2C_TEST;
        x++;
        if(x>=64)
            x=0;    
        PingPong();
        LCDBackground(0xFFFFFF);
        LCDRectangle(0xFF0000,(64-x)*64,50 ,(64-x+1)*64,50+64);    
        LCDRectangle(0x00FF00,(64-x)*64,250,(64-x+1)*64,250+64);  
        LCDRectangle(0x0000FF,(64-x)*64,450,(64-x+1)*64,450+64);
        
        while(TIMER -> TIME < nowTime + FRAME) ;
        // mdelay(FRAME);
    }
}