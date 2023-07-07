#ifndef BLOCK_H
#define BLOCK_H

#include <stdint.h>

#define BLOCK_SIZE  24
#define BLOCK_BORD  4

#define BLOCK_INNE  (BLOCK_SIZE-BLOCK_BORD)  

void BlockICE(uint32_t x,uint32_t y);
void BlockBAR(uint32_t x,uint32_t y);

#endif