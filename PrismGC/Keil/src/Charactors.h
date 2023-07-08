#ifndef CHARACTORS_H
#define CHARACTORS_H

#include <stdint.h>

#define M_BLU  0x8888FF
#define M_WHI  0xFFFFFF
#define M_LBU  0xAAAAFF
#define M_DBU  0x4444FF
#define M_BLK  0x000000

#define CHT_MAIN_SCALE_MAX 6

typedef struct 
{
    int32_t xoffset;
    uint32_t len;
    uint32_t line[16];
} CharactorLine;

void MainCharactor(uint32_t x,uint32_t y,uint8_t scale);

#endif