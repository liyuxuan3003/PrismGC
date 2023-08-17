#ifndef CHARACTORS_H
#define CHARACTORS_H

#include <stdint.h>

// MainCharactor
#define M_WHI 0
#define M_BLK 1
#define M_BLU 2
#define M_LBU 3
#define M_DBU 4

#define M_WHI_C 0xFFFFFF
#define M_BLK_C 0x000000
#define M_BLU_C 0x8888FF
#define M_LBU_C 0xAAAAFF
#define M_DBU_C 0x4444FF

#define M_BLU_G 0xC0C0C0
#define M_LBU_G 0xD3D3D3
#define M_DBU_G 0xA9A9A9

// Apple
#define A_WHI  0
#define A_BLK  1
#define A_RED  2
#define A_DKR  3
#define A_BRO  4

#define A_WHI_C 0xFFFFFF
#define A_BLK_C 0x000000
#define A_RED_C 0xED1C24
#define A_DKR_C 0xB72A32
#define A_BRO_C 0x804040

#define A_WHI_G 0xFFFFFF
#define A_BLK_G 0x000000
#define A_RED_G 0x888888
#define A_DKR_G 0x444444
#define A_BRO_G 0x444444

#define CHT_SCALE_MAX 12
#define ARROW_WID 16
#define ARROW_LEN 32
#define ARROW_BOR 4

typedef struct 
{
    int8_t xoffset;
    uint8_t len;
    uint8_t line[16];
} CharactorLine;

void MainCharactor(uint32_t x,uint32_t y,uint8_t scale);
void MainCharactorGray(uint32_t x,uint32_t y,uint8_t scale);
void Apple(uint32_t x,uint32_t y,uint8_t scale);
void AppleGray(uint32_t x,uint32_t y,uint8_t scale);
void Arrow(uint32_t x,uint32_t y,uint8_t z,uint32_t color);
void Cloud(uint32_t x,uint32_t y,int z,uint32_t size);

#endif