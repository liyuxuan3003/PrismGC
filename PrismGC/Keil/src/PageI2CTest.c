#include "PageI2CTest.h"

#include "Nunchuck.h"

#include "GlobalDefine.h"
#include "Sleep.h"

uint8_t PageI2CTest()
{
    NunchuckInit();
    struct NunchuckData ndata;

    while (1)
    {
        NunchuckInit();
        mdelay(100);
        NunchuckRead(&ndata);
        mdelay(100);
    }
    return PAGE_MAIN;
}