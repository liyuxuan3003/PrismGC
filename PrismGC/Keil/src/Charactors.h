#ifndef CHARACTORS_H
#define CHARACTORS_H

#include <stdint.h>

//色度色盘
#define M_BLU  0
#define M_WHI  1
#define A_WHI  1
#define M_LBU  2
#define M_DBU  3
#define M_BLK  4
#define A_BRO  5
#define A_RED  6
#define A_DKR  7
#define A_BLK  8

//灰度色盘（黑白不再重复定义）
// #define A_GRE  1
// #define A_DKG  2

//调色盘颜色定义
#define C_BLU  0x8888FF
#define C_WHI  0xFFFFFF
#define C_LBU  0xAAAAFF
#define C_DBU  0x4444FF
#define C_BLK  0x000000
#define C_BRO  0x804040
#define C_RED  0xED1C24
#define C_DKR  0xB72A32
#define C_BLK  0x000000
#define C_LTG  0xCCCCCC
#define C_GRE  0x888888
#define C_DKG  0x444444

#define CHT_SCALE_MAX 8
#define ARROW_WID 12
#define ARROW_LEN 32
#define ARROW_BOR 8

typedef struct 
{
    int8_t xoffset;
    uint8_t len;
    uint8_t line[16];
} CharactorLine;

void MainCharactor(uint32_t x,uint32_t y,uint8_t scale);
void Apple(uint32_t x,uint32_t y,uint8_t scale);
void AppleGray(uint32_t x,uint32_t y,uint8_t scale);
void Arrow(uint32_t x,uint32_t y,uint8_t z);

#endif