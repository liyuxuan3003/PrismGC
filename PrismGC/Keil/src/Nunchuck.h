#ifndef _NUNCHUCK_H
#define _NUNCHUCK_H

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
uint32_t NunchuckID(void);
void NunchuckReadCal(void);
int NunchuckRead(struct NunchuckData *d);
int NunchuckKey(uint8_t buttonZ);
int IsNumchuckReady();

#endif

