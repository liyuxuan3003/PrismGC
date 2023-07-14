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
    ndelay(1000);
    // udelay(5);                          //Do not touch!
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

void LCDPixelSquare(uint32_t color,uint32_t x1,uint32_t y1,uint32_t x2,uint32_t y2)
{
    for(uint32_t x=x1;x<=x2;x++)
        for(uint32_t y=y1;y<=y2;y++)
            LCDPixel(color,x,y);
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
    ndelay(1000);
    // udelay(5);                          //Do not touch!
    GPU -> ENABLE = 0;
}

//(x,y) is the top-left corner of the char 
uint8_t LCDChar(uint32_t color,uint32_t colorbck,uint32_t x,uint32_t y,uint8_t scale,uint32_t c)
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

    for (uint32_t i=0;i<h;i++)
    {
        uint8_t dots=0xAA;
        uint32_t pixels[PIXELS_MAX*CHAR_SCALE_MAX]={0};
        if(pData)
            dots=*pData++;
        for(uint32_t j=0;j<CHAR_WIDTH;j++)
        {
            uint32_t jinv=CHAR_WIDTH-j-1;
            uint32_t pixelColor;
            if(BIT_IS1(dots,j))
                pixelColor=colorbck;
            else
                pixelColor=color;

            for(int s=0;s<scale;s++)
                pixels[jinv*scale+s]=pixelColor;
        }

        for(uint32_t j=0;j<scale;j++)
        {
            // for(uint32_t s=0;s<scale;s++)
            //     LCDPixels(pixels+CHAR_WIDTH*s,x+CHAR_WIDTH*s,y+i*scale+j,CHAR_WIDTH);
            for(uint32_t s=0;s<scale/2;s++)
                LCDPixels(pixels+CHAR_WIDTH*s*2,x+CHAR_WIDTH*s*2,y+i*scale+j,CHAR_WIDTH*2);
            if(scale%2==1)
                LCDPixels(pixels+CHAR_WIDTH*(scale-1),x+CHAR_WIDTH*(scale-1),y+i*scale+j,CHAR_WIDTH);
        }

    }
	return w*scale;
}

static uint32_t mx;
static uint32_t my;
static uint32_t mcolor;
static uint32_t mcolorbck;
static uint8_t  mscale;

static void _OutChar(uint8_t c)
{
    mx+=LCDChar(mcolor,mcolorbck,mx,my,mscale,c);
    return;
}

uint32_t LCDPrintf(uint32_t color,uint32_t colorbck,uint32_t x,uint32_t y,uint8_t scale,
const char *fmt,...)
{
    va_list va;
    va_start(va, fmt);
    mx=x;
    my=y;
    mcolor=color;
    mcolorbck=colorbck;
    mscale=scale;
    _xprint(_OutChar,fmt,va);
    va_end(va);
    return mx;
}

