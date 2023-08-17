#ifndef PAGEMENU_H
#define PAGEMENU_H

#include <stdint.h>

// #define MENU_BG_COL 0x6E9389
#define MENU_BG_COL 0x13939C

#define PAGEMAX 3
#define IMAX 4
#define JMAX 4
#define LEVELNUM_PER_PAGE IMAX*JMAX
#define MENUXBORD LEVEL_BLOCK_SIZE*2*3
#define MENUYBORD 118
#define INTERVALXBLOCK 2
#define INTERVALYBLOCK 42

uint8_t PageMenu();


#endif