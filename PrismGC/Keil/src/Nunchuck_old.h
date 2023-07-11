#ifndef NUNCHUCK_H
#define NUNCHUCK_H

#include <stdint.h>

struct NunchuckData
{
	uint8_t sx;
	uint8_t sy;
	uint16_t ax;
	uint16_t ay;
	uint16_t az;
	uint8_t bc;
	uint8_t bz;
};

int NunchuckInit();
int NunchuckRead(struct NunchuckData *d);

#endif

