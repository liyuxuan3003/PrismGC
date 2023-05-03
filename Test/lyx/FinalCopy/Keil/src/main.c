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

#define T0 200
#define T1 180

#define N8(t) t 
#define N4(t) t,t 
#define N2(t) t,t,t,t

#define L8 T1
#define L4 T0,T1 
#define L2 T0,T0,T0,T1

static const uint8_t noteArr[] = 
{
    N4(1),N4(2),N4(3),N4(1),
    N4(1),N4(2),N4(3),N4(1),
    N4(3),N4(4),N2(5),
    N4(3),N4(4),N2(5),
    N8(5),N8(6),N8(5),N8(4),N4(3),N4(1),
    N8(5),N8(6),N8(5),N8(4),N4(3),N4(1),
    N4(1),N4(1),N2(1),
    N4(1),N4(1),N2(1)
};

static const uint16_t noteLenArr[] =
{
    L4,L4,L4,L4,
    L4,L4,L4,L4,
    L4,L4,L2,
    L4,L4,L2,
    L8,L8,L8,L8,L4,L4,
    L8,L8,L8,L8,L4,L4,
    L4,L4,L2,
    L4,L4,L2
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
    LCDRectangle(0xFF0000,0,0,64,64,64);
    LCDRectangle(0x00FF00,128,128,192,192,64);
    LCDRectangle(0x0000FF,256,256,320,320,64);

    int noteCnt = 0;
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

        if(SWI_7(P))
        {
            if(noteCnt >= sizeof(noteArr)/sizeof(noteArr[0]))
                noteCnt = 0;
            BUZZER -> NOTE = noteArr[noteCnt];
            BUZZER -> TIME = noteLenArr[noteCnt];
            noteCnt++;
        }
        // LCDBackground(0xFFFFFF);
        // LCDRectangle(0xFF0000,16,16,16+256,16+256,16);
        // LCDRectangle(0x0000FF,-x*16,20,-x*16+64 ,20+64 ,1 );

        // mdelay(T0);
    
// #ifdef HDMI        
//         HDMI -> PIXEL = HDMI -> X_POS + 0xFF * HDMI -> Y_POS;
// #endif        
#ifdef GPU
        if(SWI_6(P))
        {
            x++;
            if(x>=1024)
                x=0;
            PingPong();
            mdelay(50);
            LCDBackground(0xFFFFFF);
            LCDRectangle(0xFF0000,128,128,192,192,64);
            LCDRectangle(0x00FF00,256,256,320,320,64);
            // LCDRectangle(0xFF0000,16,16,16+256,16+256,16);
            // LCDRectangle(0x0000FF,-x*16,20,-x*16+64 ,20+64 ,16 );
            mdelay(2*T0);
            PingPong();
            mdelay(50);
            LCDBackground(0xFFFFFF);
            LCDRectangle(0x00FFFF,128,128,192,192,64);
            LCDRectangle(0xFF00FF,256,256,320,320,64);
            // LCDRectangle(0x00FF00,16,16,16+256,16+256,16);
            // LCDRectangle(0x0000FF,-x*16,20,-x*16+64 ,20+64 ,16 );
            mdelay(2*T0);
            // LCDRectangle(0x00FFFF,+x*16,220,+x*16+64 ,220+64 ,16 );
            // LCDRectangle(0xFFFF00,-x*16,220,-x*16+64 ,220+64 ,16 );
        }
        if(SWI_5(P))
        {
            PingPong();
            mdelay(2*T0);
            PingPong();
            mdelay(2*T0);
        }
#endif        
	}
}

