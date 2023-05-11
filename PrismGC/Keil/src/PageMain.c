#include "PageMain.h"

#include "HardwareConfig.h"
#include "KeyBoard.h"
#include "GPULite.h"
#include "GlobalDef.h"

uint8_t PageMain()
{
    PORTA -> O_LED_DAT = 0x05;
    uint16_t x = 0;
    while(1)
    {
        PingPong();
        LCDBackground(0xFFFFFF);
        LCDRectangle(0xFF0000,(64-x)*16,50 ,(64-x)*16+64,50+64 ,16);
        LCDRectangle(0x00FF00,(64-x)*16,250,(64-x)*16+64,250+64,16);  
        LCDRectangle(0x0000FF,(64-x)*16,450,(64-x)*16+64,450+64,16);
        x++;
        if(x>=64)
            x=0;
        if(KEYBOARD -> KEY != 0xFF)
            return PAGE_BLOCK_GAME;
    }
}