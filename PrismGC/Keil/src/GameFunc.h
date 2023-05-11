#ifndef GAMEFUNC_H
#define GAMEFUNC_H

#include <stdint.h>

#define H_DISP 1024
#define V_DISP 600

#define BLOCK_SIZE 16
#define H_SPEED 16
#define V_SPEED 16

uint16_t MoveX(uint16_t x1);
uint16_t AutoY(uint16_t y1);

#endif