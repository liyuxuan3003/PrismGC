/*
* Copyright (c) 2023 by Liyuxuan,all rights reserved
*/

#ifndef _CONSOLE_H
#define _CONSOLE_H

#include "fmtio.h"

#ifndef PRINTF
  #define printf conPrintf
#endif

void conInit(int port,int32_t baud);
int conReadData(char *pData,int count);
int conPrintf(const char *fmt,...);

#endif

