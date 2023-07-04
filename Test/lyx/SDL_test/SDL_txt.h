/*
 * Copyright (c) 2023 by Liyuxuan,all rights reserved
 */

#include <SDL2/SDL.h>

void SDL_SetTextColor(unsigned char r,unsigned char g,unsigned char b,unsigned char a);
void SDL_SetBackColor(unsigned char r,unsigned char g,unsigned char b,unsigned char a);
int SDL_RenderDrawChar(SDL_Renderer *pRender,int x,int y,int c);
int SDL_RenderDrawText(SDL_Renderer *pRender,int x,int y,const char *fmt,...);

