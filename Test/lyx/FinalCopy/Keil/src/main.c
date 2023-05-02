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
#include "KeyBoard.h"

static const uint8_t noteArr[] = 
{
    1,1,2,2,3,3,1,1,
    1,1,2,2,3,3,1,1,
    3,3,4,4,5,5,5,5,
    3,3,4,4,5,5,5,5,
    5,6,5,4,3,3,1,1,
    5,6,5,4,3,3,1,1,
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
    0
};

static const uint16_t noteLenArr[] =
{
    100,80,100,80,100,80,100,80,
    100,80,100,80,100,80,100,80,
    100,80,100,80,100,100,100,80,
    100,80,100,80,100,100,100,80,
    80,80,80,80,100,80,100,80,
    80,80,80,80,100,80,100,80,
    100,80,100,80,100,100,100,80,
    100,80,100,80,100,100,100,80,
    100
};

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
    // LCDRectangle(0xFF0000,0,0,64,64,64);
    // LCDRectangle(0x00FF00,128,128,192,192,64);
    // LCDRectangle(0x0000FF,256,256,320,320,64);
    // LCDRectangle(0xFFFF00,192,192,320,320,16);
    // LCDRectangle(0xFF00FF,208,208,336,336,16);
    // LCDRectangle(0x0000FF,128,0,192,64,64);
    // LCDRectangle(0x000000,0,128,64,192,64);

    int noteCnt = 0;

    for(int i=0;i<512;i++)
    {
        LCDRectangle(0x000011*i,64*i,64*i,64*i+64,64*i+64,64);
        if(noteCnt >= sizeof(noteArr)/sizeof(noteArr[0]))
            noteCnt = 0;
        BUZZER -> NOTE = noteArr[noteCnt];
        BUZZER -> TIME = noteLenArr[noteCnt];
        noteCnt++;
        mdelay(400);
    }

    // LCDRectangle(0xFF0000,+x*16,20,+x*16+256,20+256,16);
    // LCDRectangle(0x0000FF,-x*16,20,-x*16+64 ,20+64 ,1 );
    // LCDRectangle(0x00FFFF,+x*16,220,+x*16+64 ,220+64 ,16 );
    // LCDRectangle(0xFFFF00,-x*16,220,-x*16+64 ,220+64 ,16 );
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
    for(unsigned int i=0;i<4;i++)
    {
        DIG[i].ENA = 1;
    }

    

	while(1)
	{
        for(unsigned int i=0;i<4;i++)
            DIG[i].COD ++;
        PORTA -> O_LED_DAT = PORTA -> I_SWI_DAT;
        // PORTA -> O_LED_DAT = KEYBOARD -> KEY;
        // uint8_t a = PORTA -> O_LED_DAT;
        // UARTWrite(a);

        if(SWI_7(P))
        {
            if(noteCnt >= sizeof(noteArr)/sizeof(noteArr[0]))
                noteCnt = 0;
            BUZZER -> NOTE = noteArr[noteCnt];
            BUZZER -> TIME = noteLenArr[noteCnt];
            noteCnt++;
        }
#ifdef HDMI        
        HDMI -> PIXEL = HDMI -> X_POS + 0xFF * HDMI -> Y_POS;
#endif        
#ifdef GPU
        if(SWI_6(P))
        {
            x++;
            if(x>=1024)
                x=0;
            LCDBackground(0xFFFFFF);
            LCDRectangle(0xFF0000,+x*16,20,+x*16+256,20+256,16);
            LCDRectangle(0x0000FF,-x*16,20,-x*16+64 ,20+64 ,1 );
            LCDRectangle(0x00FFFF,+x*16,220,+x*16+64 ,220+64 ,16 );
            LCDRectangle(0xFFFF00,-x*16,220,-x*16+64 ,220+64 ,16 );
        }
#endif        
        mdelay(100);
	}
}

