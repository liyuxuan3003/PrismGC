/*
 * Copyright (c) 2022-2023 by LLoong,all rights reserved
 */
/**
 * @file
 * @brief GamePad main
 * @author Li zhuoyi(li@lloong.cn)
 *
 * @date 2022-11-18 初始版本
 *
 **/

#include <stdio.h>
#include <SDL2/SDL.h>
#include "font.h"
#include "../platform/fmtio.h"

unsigned char m_TextColor[]={0xf0,0xf0,0xf0,0xff};
unsigned char m_BackColor[]={0x20,0x20,0x80,0xff};

void SDL_SetTextColor(unsigned char r,unsigned char g,unsigned char b,unsigned char a)
{
	m_TextColor[0]=r;
	m_TextColor[1]=g;
	m_TextColor[2]=b;
	m_TextColor[3]=a;
}

void SDL_SetBackColor(unsigned char r,unsigned char g,unsigned char b,unsigned char a)
{
	m_TextColor[0]=r;
	m_TextColor[1]=g;
	m_TextColor[2]=b;
	m_TextColor[3]=a;
}

static void SDL_WriteDots(SDL_Renderer *pRender,int x,int y,unsigned char dots)
{
    unsigned int i;
    unsigned char d=dots;
    int x0=x;
	for (i=0;i<8;i++)
	{
		if(dots&0x80)
			SDL_SetRenderDrawColor(pRender,
				m_TextColor[0],m_TextColor[1],m_TextColor[2],m_TextColor[3]);
		else
			SDL_SetRenderDrawColor(pRender,
				m_BackColor[0],m_BackColor[1],m_BackColor[2],m_BackColor[3]);
		SDL_RenderDrawPoint(pRender,x,y);
		x++;
		dots<<=1;
	}
	y++;
	x=x0;
	dots=d;
}

int SDL_RenderDrawChar(SDL_Renderer *pRender,int x,int y,int c)
{
    int i,j;
    const struct Font *pFont;
    const unsigned char *pData=NULL;
    int w=8,h=16;

    pFont=get_fontglyph(c);
	if(pFont)
	{
		w=pFont->width;
		h=pFont->height;
		pData=pFont->pixels;
		w=((w+7)>>3)<<3;
	}
	for (i=0;i<w;i+=8)
		for (j=0;j<h;j++)
	{
		unsigned char dots=0;
		if(pData)
			dots=~*pData++;
		SDL_WriteDots(pRender,x+i,y+j,dots);
	}
	return w;
}

#ifdef SDL_lite	
static SDL_Renderer *m_pRender;
static int m_x;
static int m_y;
static void SDL_OutChar(unsigned char c)
{
	m_x+=SDL_RenderDrawChar(m_pRender,m_x,m_y,c);
}
#endif

int SDL_RenderDrawText(SDL_Renderer *pRender,int x,int y,const char *fmt,...)
{
	va_list va;
	va_start(va, fmt);
#ifdef SDL_lite	
	m_x=x;
	m_y=y;
	m_pRender=pRender;
	_xprint(SDL_OutChar,fmt,va);
#else
	int m_x=x;
	char buf[1000];
	vsnprintf(buf,sizeof(buf),fmt,va);
	for(char *p=buf;*p;p++)
		m_x+=SDL_RenderDrawChar(pRender,m_x,y,*p);
#endif	
	va_end(va);
	return m_x;
}

