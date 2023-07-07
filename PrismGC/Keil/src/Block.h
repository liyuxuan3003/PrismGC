#ifndef BLOCK_H
#define BLOCK_H

#include <stdint.h>

#define BLOCK_SIZE  24
#define BLOCK_BORD  4
#define COLOR_ICE 0xCCCCFF
#define COLOR_BOR 0xFFFFFF
#define COLOR_GRO 0xFFFFFF
#define BLOCK_INNE  (BLOCK_SIZE-BLOCK_BORD)  

void BlockICE(uint32_t x,uint32_t y);
void BlockBAR(uint32_t x,uint32_t y);
void BlockBorder(uint32_t x,uint32_t y);
void BlockEND(uint32_t x,uint32_t y);
void BlockTRP(uint32_t x,uint32_t y);

#endif