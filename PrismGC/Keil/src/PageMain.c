#include "PageMain.h"

#include "GlobalDefine.h"

#include "Sleep.h"
#include "GPIO.h"
#include "HardwareConfig.h"
#include "Timer.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"
#include "BGM.h"

#include <string.h>

uint8_t PageMain()
{
    uint32_t nowTime;
    uint16_t x=0;
    BUZZER -> NOTE = 0;
    while(1)
    {
        nowTime = TIMER -> TIME;
        if(KEYBOARD -> KEY != 0xFF)
        {
            switch (KEYBOARD -> KEY)
            {
                case 0x00: return PAGE_BLOCK_GAME; break;
                case 0x01: return PAGE_CHAR_TEST; break;
                case 0x02: return PAGE_MAZE_GAME; break;
                case 0x0F: break;
                default: break;
            }
        }
            
        if(SWI_7(P)==0)
            BGMPageMain();

        x++;
        if(x>=64)
            x=0;    
        PingPong();
        LCDBackground(0xFFFFFF);
        LCDRectangle(0xFF0000,(64-x)*64,50 ,(64-x+1)*64,50+64);    
        LCDRectangle(0x00FF00,(64-x)*64,250,(64-x+1)*64,250+64);  
        LCDRectangle(0x0000FF,(64-x)*64,450,(64-x+1)*64,450+64);
        
        while(TIMER -> TIME < nowTime + FRAME) ;
    }
}