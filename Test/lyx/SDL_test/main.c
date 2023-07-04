/*
 * Copyright (c) 2023 by Liyuxuan,all rights reserved
 */

#include <stdio.h>
#include <SDL2/SDL.h>
#include "SDL_txt.h"

int main(int argc,char *argv[]) 
{
	int zoom=1;
	int w=640;
	int h=480;
#ifndef SDL_lite	
	if(argc>1)
		zoom=strtol(argv[1],NULL,0);
	if(argc>2)
		w=strtol(argv[2],NULL,0);
	if(argc>3)
		h=strtol(argv[3],NULL,0);
#endif		

	if (SDL_Init(SDL_INIT_EVERYTHING)==-1)
	{
		printf("SDL_Init Failed: %s\n",SDL_GetError());
		return -1;
	}
	SDL_Window *pWindow = SDL_CreateWindow("SDL2 Hello",
		SDL_WINDOWPOS_UNDEFINED,SDL_WINDOWPOS_UNDEFINED, w*zoom,h*zoom,0);
	if(pWindow==NULL)
	{
		printf("SDL_CreateWindow FAILED: %s\n",SDL_GetError());
		return -2;
	}

	SDL_Renderer *pRender = SDL_CreateRenderer(pWindow,-1,SDL_RENDERER_ACCELERATED);
	//SDL_Renderer *pRender = SDL_CreateRenderer(pWindow,-1,SDL_RENDERER_SOFTWARE);
	if(pRender==NULL)
	{
		printf("SDL_CreatRender FAILED: %s\n",SDL_GetError());
		return -2;
	}

	SDL_Texture *pTexture = SDL_CreateTexture(pRender, SDL_PIXELFORMAT_RGBA8888, 
		SDL_TEXTUREACCESS_TARGET, w*zoom, h*zoom);

	SDL_SetRenderTarget(pRender,pTexture);
	SDL_RenderSetScale(pRender,zoom,zoom);
	SDL_RenderDrawText(pRender,250,100,"Hello, world!\n");
	SDL_RenderDrawLine(pRender,0,25,w,25);
	SDL_RenderDrawLine(pRender,0,h-25,w,h-25);
	SDL_RenderDrawLine(pRender,25,0,25,h);
	SDL_RenderDrawLine(pRender,w-25,0,w-25,h);
	SDL_Rect rect={200,200,250,20};
	SDL_RenderDrawRect(pRender,&rect);
	rect.y=300;
	SDL_RenderFillRect(pRender,&rect);
	SDL_RenderPresent(pRender);

	int running=1;
	int update=1;
	int cnt=0;
	while(running)
	{
 		SDL_Event event;
		if(SDL_PollEvent(&event))
		{
			int key;
			int mod;
			cnt++;
			SDL_RenderDrawText(pRender,250,150,"evType=%u,cnt=%d\n",(int)event.type,cnt);
			update=1;
			switch (event.type)
			{
			case SDL_QUIT:
				running = 0;
				break;
			case SDL_KEYDOWN:
				key=event.key.keysym.sym;
				mod=event.key.keysym.mod;
				if(mod&KMOD_CTRL)
				{
					if (key==SDLK_ESCAPE)
						running = 0;
				}
				if(key=='0')
					running = 0;
				break;
			case SDL_MOUSEBUTTONUP:
				key=event.button.button;
				if(key==SDL_BUTTON_LEFT)
					running=0;
				break;
			case SDL_FINGERDOWN:
				{
					int x=event.tfinger.x*w*zoom;
					int y=event.tfinger.y*w*zoom;
					SDL_RenderDrawText(pRender,0,32,"x=%d,y=%d\n",x,y);
				}
				break;
			}
			if(update)
			{
				update=0;
				SDL_SetRenderTarget(pRender,NULL);
				SDL_RenderCopy(pRender, pTexture, NULL, NULL);
				SDL_RenderPresent(pRender);
				SDL_SetRenderTarget(pRender,pTexture);
				SDL_RenderSetScale(pRender,zoom,zoom);
			}
		}
	}	
    SDL_Quit();
	return 0;
}

