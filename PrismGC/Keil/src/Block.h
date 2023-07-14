#ifndef BLOCK_H
#define BLOCK_H

#include <stdint.h>

#define BLOCK_SIZE  24
#define BLOCK_BORD  4
#define BLOCK_INNE  (BLOCK_SIZE-BLOCK_BORD)  

#define COLOR_ICE 0xCCCCFF
#define COLOR_BAR 0xFFFFFF
#define COLOR_BOR 0xFFFFFF
#define COLOR_GRO 0xFFFFFF
#define COLOR_TRA 0x0000FF
#define COLOR_DEL 0xFFFF00

#define COLOR_MAC 0x804040
#define COLOR_MAC_ARR 0xFFFFFF

#define COLOR_DIR 0x00FF00
#define COLOR_DIR_ARR 0xFFFFFF
// #define COLOR_DIR 0x1155DD

#define COLOR_GRA 0xCCCCCC
#define COLOR_GRA_BUT 0x888888

void BlockBorder(uint32_t x,uint32_t y);

void BlockICE(uint32_t x,uint32_t y);
void BlockBAR(uint32_t x,uint32_t y);
void BlockEND(uint32_t x,uint32_t y);
void BlockTRP(uint32_t x,uint32_t y);
void BlockDIR(uint32_t x,uint32_t y,uint32_t z);
void BlockMAC(uint32_t x,uint32_t y,uint32_t z);
void BlockGRA(uint32_t x,uint32_t y,uint8_t hit);

#endif