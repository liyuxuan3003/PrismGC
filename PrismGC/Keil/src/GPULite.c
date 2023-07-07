#include "GPULite.h"
#include "Sleep.h"

#include "Font.h"

#include "BitOperate.h"

#include "Console.h"

#include <stdlib.h>
#include <string.h>

void WaitRamReady()
{
    while(!GPU -> SYS_VAILD) ;
    GPU -> PING_PONG = 0x0;         //0M
}

static void RamWrite(uint32_t x_pos,uint32_t y_pos,uint32_t pixel,uint32_t len)
{
    GPU -> X_POS = x_pos;
    GPU -> Y_POS = y_pos;
    GPU -> PIXEL = pixel;
    GPU -> LEN = len;
    GPU -> SYS_WR_LEN = (len <= 8) ? len : 8;
    GPU -> ENABLE = 1;
    __asm("nop");
    __asm("nop");
    while(GPU -> BUSY) ;
    udelay(5);                          //Do not touch!
    GPU -> ENABLE = 0;
}

void PingPong()
{
    // while(GPU -> BUSY) ;
    GPU -> PING_PONG = !GPU -> PING_PONG;
}

void LCDBackground(uint32_t color)
{
    RamWrite(0,0,color,H_DISP*V_DISP);
}

void LCDRectangle(uint32_t color,uint32_t x1,uint32_t y1,uint32_t x2,uint32_t y2)
{
    uint32_t len=x2-x1;
    for(uint32_t y=y1;y<=y2;y++)
    {
        RamWrite(x1,y,color,len);
    }
}

void LCDPixel(uint32_t color,uint32_t x,uint32_t y)
{
    RamWrite(x,y,color,1);
}

void LCDPixels(const uint32_t *colors,uint32_t x,uint32_t y,uint32_t len)
{   
    //len must smaller than 64 !
    GPU->X_POS=x;
    GPU->Y_POS=y;
    GPU->PIXEL = colors[0];
    for(int i=0;i<len;i++)
        GPU_PIXELS[i]=colors[i];
    GPU -> LEN = len;
    GPU -> SYS_WR_LEN = (len <= 8) ? len : 8;
    GPU -> ENABLE = 3;
    __asm("nop");
    __asm("nop");
    while(GPU -> BUSY) ;
    udelay(5);                          //Do not touch!
    GPU -> ENABLE = 0;
}

//(x,y) is the top-left corner of the char 
uint8_t LCDChar(uint32_t color,uint32_t colorbck,uint32_t c,uint32_t x,uint32_t y,uint8_t scale)
{
    const struct Font *pFont;
    const uint8_t *pData=NULL;

    int w=8;
    int h=16;

    pFont=GetFontGlyph(c);
	if(pFont)
	{
		w=pFont->width;
		h=pFont->height;
		pData=pFont->pixels;
	}

    for (int i=0;i<h;i++)
    {
        uint8_t dots=0xAA;
        uint32_t *colors=(uint32_t *)malloc(sizeof(uint32_t)*8*scale);
        if(pData)
            dots=*pData++;
        for(int j=0;j<8;j++)
        {
            for(int s=0;s<scale;s++)
            {
                // printf("%d ",8*scale-1-j*scale-s);
                if(BIT_IS1(dots,j))
                    colors[8*scale-1-j*scale-s]=colorbck;
                else
                    colors[8*scale-1-j*scale-s]=color;
            }
        }
        // printf("\r\n");
        for(int s=0;s<scale;s++)
            LCDPixels(colors,x,y+i*scale+s,8*scale);
        free(colors);
    }
	return w;
}

