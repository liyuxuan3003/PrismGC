#ifndef GETKEY_H
#define GETKEY_H

#include <stdint.h>

#define KEY_L 1     //Left
#define KEY_R 2     //Right
#define KEY_U 3     //Up
#define KEY_D 4     //Down
#define KEY_C 5     //Center
#define KEY_E 6     //Exit

uint8_t GetKey(uint8_t buttonZ);
uint8_t IsDirection(uint8_t key);

#endif