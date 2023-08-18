typedef struct
{
    volatile uint32_t RX_DATA;
    volatile uint32_t TX_STATE;
    volatile uint32_t TX_DATA;
} UARTType;

#define UART ((UARTType *)UART_BASE)