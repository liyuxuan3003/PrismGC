#ifndef BLOCK_H
#define BLOCK_H

#include <stdint.h>

#define BLOCK_SIZE  24
#define BLOCK_BORD  4
#define BLOCK_INNE  (BLOCK_SIZE-BLOCK_BORD)  

#define COLOR_BOR 0xFFFFFF

#define COLOR_ICE 0xCCCCFF
#define COLOR_BAR 0xFFFFFF
#define COLOR_END 0x33EE88

#define COLOR_DIR 0x1155DD
#define COLOR_DIR_ARR 0xFFFFFF

#define COLOR_GRA 0xCCCCCC
#define COLOR_GRA_BUT 0x888888

#define COLOR_POR 0x333333
#define COLOR_POR_SY1 0xCC8888
#define COLOR_POR_SY2 0x88CC88
#define COLOR_POR_SY3 0x8888CC

// #define COLOR_TRP 0x000000

#define COLOR_ANM 0xFF0000
#define COLOR_MCG 0x0000FF
#define COLOR_DOR 0x884400
#define COLOR_DOR_BOARD 0xCCCC00

#define COLOR_TRP 0x00CCFF

#define COLOR_BUT_OPEN 0x00FF00
#define COLOR_BUT_EXCUTING 0xFFFF00
#define COLOR_BUT_CLOSE 0xFF0000

/*-------------------------------*/

#define COLOR_GRO 0xFFFFFF

#define COLOR_TRA 0x0000FF
#define COLOR_DEL 0xFFFF00

#define COLOR_MAC 0x804040
#define COLOR_MAC_ARR 0xFFFFFF

/*-------------------------------*/

void BlockBorder(uint32_t x,uint32_t y);

void BlockICE(uint32_t x,uint32_t y);
void BlockBAR(uint32_t x,uint32_t y);
void BlockEND(uint32_t x,uint32_t y);
void BlockDIR(uint32_t x,uint32_t y,uint32_t z);
void BlockGRA(uint32_t x,uint32_t y,uint8_t hit);
void BlockPOR(uint32_t x,uint32_t y,uint32_t id);
void BlockTRP(uint32_t x,uint32_t y);
void BlockANM(uint32_t x,uint32_t y);
void BlockMCG(uint32_t x,uint32_t y);
void BlockDOR(uint32_t x,uint32_t y,uint32_t opensign);
void BlockBUT(uint32_t x,uint32_t y,uint32_t opensign);

// void BlockMAC(uint32_t x,uint32_t y,uint32_t z);
// void BlockTRP(uint32_t x,uint32_t y);

#endif