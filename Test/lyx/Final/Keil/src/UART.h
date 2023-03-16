#include <stdint.h>

//INTERRUPT DEF
#define NVIC_CTRL_ADDR (*(volatile unsigned *)0xe000e100) 

//UART DEF
typedef struct
{
    volatile uint32_t UARTRX_DATA;
    volatile uint32_t UARTTX_STATE;
    volatile uint32_t UARTTX_DATA;
} UARTType;

#define UART_BASE 0x40000010
#define UART ((UARTType *)UART_BASE)

void Delay(int interval);

char ReadUARTState(void);

char ReadUART(void);
void WriteUART(char data);

void UARTString(char *stri);
void UARTHandle(void);