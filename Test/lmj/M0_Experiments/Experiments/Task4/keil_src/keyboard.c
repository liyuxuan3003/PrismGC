#include <stdint.h>
#include "code_def.h"

uint32_t key3_flag;
uint32_t key2_flag;
uint32_t key1_flag;
uint32_t key0_flag;

void KEY0(void)
{
	SetWaterLightMode(0);
}

void KEY1(void)
{
	SetWaterLightMode(1);
}

void KEY2(void)
{
	SetWaterLightMode(2);
}

void KEY3(void)
{
	SetWaterLightMode(3);
}
