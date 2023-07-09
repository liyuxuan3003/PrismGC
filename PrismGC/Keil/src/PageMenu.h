#ifndef PAGEMENU_H
#define PAGEMENU_H

#include <stdint.h>

#define PAGEMAX 2

void LevelMenu (uint32_t x,uint32_t y,int type,int NUM);
void BlockMenu (uint32_t x,uint32_t y,int type);
void HighLight (uint32_t x,uint32_t y);
uint8_t PageMenu();


#endif