#ifndef PAGEBLOCKGAME_H
#define PAGEBLOCKGAME_H

#include <stdint.h>

#define BLOCK_SIZE 16
#define H_SPEED 16
#define V_SPEED 16

uint8_t PageBlockGame();
uint16_t MoveX(uint16_t x1);
uint16_t AutoY(uint16_t y1);

uint16_t ScoreDetermination(uint16_t x1, uint16_t l, uint8_t Score);
uint16_t HealthDetermination(uint16_t x1, uint16_t l, uint8_t Health);

#endif