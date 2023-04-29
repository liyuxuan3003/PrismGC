#ifndef UART_H
#define UART_H

#include <stdint.h>

#include "Peripheral.h"

//UART DEF
typedef struct
{
    volatile uint32_t RX_DATA;
    volatile uint32_t TX_STATE;
    volatile uint32_t TX_DATA;
} UARTType;

#define UART ((UARTType *)UART_BASE)

char UARTReadState(void);

char UARTRead(void);
void UARTWrite(char data);

void UARTString(char *stri);
void UARTHandle(void);

#endif