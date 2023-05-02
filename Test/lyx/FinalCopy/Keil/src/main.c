#include <string.h>
#include <stdint.h>

#include "BitOperate.h"

#include "Sleep.h"

#include "Interrupt.h"
#include "HardwareConfig.h"
#include "UART.h"
#include "GPIO.h"
#include "Digit.h"
//#include "SDRAM.h"
//#include "HDMI.h"
#include "GPULite.h"
#include "Buzzer.h"

int main() 
{ 
#ifdef SDRAM   
    SDRAM[0x1111] = 0x11223344;
    uint32_t a;
    for(int i=0;i<20;i++)
    {
        a = SDRAM[0x1111];
        if(a==0x11223344)
            break;
    }
#endif      
#ifdef GPU
    WaitRamReady();
    LCDBackground(0xFFFFFF);
    int x=0;
#endif    
	//interrupt initial
	NVIC_CTRL_ADDR = 1;

	//UART display
	UARTString("Cortex-M0 Start up!\r\n");

    //PORTA IO STATUS
    PORTA -> O_SWI_ENA = 0x00;
    PORTA -> O_LED_ENA = 0xFF;

    //PORTA INIT
    PORTA -> O_LED_DAT = 0x00;

    DIG_CRTL = 0xF;
    for(int i=0;i<4;i++)
    {
        DIG[i].ENA = 1;
    }

	while(1)
	{
        for(int i=0;i<4;i++)
            DIG[i].COD ++;
        PORTA -> O_LED_DAT = PORTA -> I_SWI_DAT;
        uint8_t a = PORTA -> O_LED_DAT;
        UARTWrite(a);
        BUZZER -> NOTE ++;
        BUZZER -> TIME = 200;
#ifdef HDMI        
        HDMI -> PIXEL = HDMI -> X_POS + 0xFF * HDMI -> Y_POS;
#endif        
#ifdef GPU
        x++;
        if(x>=1024)
            x=0;
        LCDBackground(0xFFFFFF);
        LCDRectangle(0xFF0000,+x*16,20,+x*16+256,20+256,16);
        LCDRectangle(0x0000FF,-x*16,20,-x*16+64 ,20+64 ,1 );
        LCDRectangle(0x00FFFF,+x*16,220,+x*16+64 ,220+64 ,16 );
        LCDRectangle(0xFFFF00,-x*16,220,-x*16+64 ,220+64 ,16 );
#endif        
        mdelay(500);
	}
}

