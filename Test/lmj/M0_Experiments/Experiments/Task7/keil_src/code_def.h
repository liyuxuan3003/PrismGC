#include <stdint.h>
#define NVIC_CTRL_ADDR (* (volatile unsigned *) 0xe000e100)
#define Keyboard_keydata_clear (*(volatile unsigned*) 0x40000000)
#define Music_data (*(volatile unsigned*) 0x40000010)

void KEY_ISR(void);