#include "GPULite.h"
#include "Sleep.h"

#include "Font.h"

#include "BitOperate.h"

#include <stdlib.h>

void WaitRamReady()
{
    while(!GPU -> SYS_VAILD) ;
    GPU -> PING_PONG = 0x0;         //0M
}

void RamWrite(uint32_t x_pos,uint32_t y_pos,uint32_t pixel,uint32_t len)
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

void LCDRectangleDel(uint32_t color,uint32_t x1,uint32_t y1,uint32_t dx,uint32_t dy)
{
    LCDRectangle(color,x1,y1,x1+dx,y1+dy);
}

void LCDPixel(uint32_t color,uint32_t x,uint32_t y)
{
    RamWrite(x,y,color,1);
}

int LCDChar(int x,int y,int c)
{
    int i,j;
    const struct Font *pFont;
    const unsigned char *pData=NULL;
    int w=8,h=16;

    pFont=GetFontGlyph(c);
	if(pFont)
	{
		w=pFont->width;
		h=pFont->height;
		pData=pFont->pixels;
		w=((w+7)>>3)<<3;
	}

	for (i=0;i<w;i+=8)
    {
		for (j=0;j<h;j++)
        {
            unsigned char dots=0;
            if(pData)
                dots=*pData++;
            for(int k=0;k<8;k++)
            {
                if(BIT_IS1(dots,k))
                    LCDPixel(0xFFFFFF,x+i+8-k,y+j);
                else
                    LCDPixel(0x000000,x+i+8-k,y+j);
            }  
        }
    }
	return w;
}