#include "I2C.h"

#include "HardwareConfig.h"
#include "Sleep.h"

void I2C()
{
    //init
    SDA(O);
    SDA(H);
    SCL(O);
    SCL(H);
    ndelay(T_SU_STA);
    
    SCL(L);
    ndelay(T_HD_STA);

    SDA(H);
    ndelay(T_LOW);

    //8-bit data
    
}