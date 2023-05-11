#include "PageMain.h"

#include "Sleep.h"

#include "HardwareConfig.h"
#include "Digit.h"
#include "GPULite.h"
#include "Buzzer.h"
#include "KeyBoard.h"
#include "GameFunc.h"

uint8_t PageMain()
{
    uint16_t x;
    // int cnt=10; 
    while(1)
    {        
        PingPong();
        LCDBackground(0xFFFFFF);
        x++;
        if(x>=64)
            x=0;
        LCDRectangle(0xFF0000,(64-x)*16,50 ,(64-x)*16+64,50+64 ,16);
        LCDRectangle(0x00FF00,(64-x)*16,250,(64-x)*16+64,250+64,16);  
        LCDRectangle(0x0000FF,(64-x)*16,450,(64-x)*16+64,450+64,16);
        if(!SWI_6(P))
        {
            return 1;
        }
    }
}