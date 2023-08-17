#include "PageI2CTest.h"

#include "Nunchuck.h"

#include "GlobalDefine.h"
#include "Sleep.h"

#include "GPULite.h"
#include "KeyBoard.h"

#include "Console.h"

uint8_t PageI2CTest()
{
    struct NunchuckData ndata;

    int initStatus=NunchuckInit();
    mdelay(100);

    while(1)
    {
        PingPong();
        LCDBackground(BLACK);

        printf("I2C Test!\r\n");

        if(KEYBOARD->KEY==0x0F)
            return PAGE_MAIN;
            
        LCDPrintf(WHITE,BLACK,100,100,2,"initStatus: %d",initStatus);
        // LCDPrintf(WHITE,BLACK,100,150,2,"key: %c",NunchuckKey());

        NunchuckRead(&ndata);
        mdelay(100);
    }
}