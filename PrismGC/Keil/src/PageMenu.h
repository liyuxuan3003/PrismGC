#ifndef PAGEMENU_H
#define PAGEMENU_H

#include <stdint.h>

#define PAGEMAX 2
#define IMAX 4
#define JMAX 4
#define LEVELNUM_PER_PAGE IMAX*JMAX
#define MENUXBORD LEVEL_BLOCK_SIZE*2*3
#define MENUYBORD 100
#define INTERVALXBLOCK 2
#define INTERVALYBLOCK 48

uint8_t PageMenu();


#endif