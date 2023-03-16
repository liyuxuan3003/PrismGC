#include <string.h>

#include "UART.h"

void Delay(int interval)
{
    volatile int i = 0;
    while(1) 
    {
        i = i + 1;
        if(i == interval) break;
    }
}
 
char ReadUARTState()
{
    char state;
	state = UART -> UARTTX_STATE;
    return(state);
}

char ReadUART()
{
    char data;
	data = UART -> UARTRX_DATA;
    return(data);
}

void WriteUART(char data)
{
    while(ReadUARTState());
	UART -> UARTTX_DATA = data;
}

void UARTString(char *stri)
{
	int i;
	for(i=0;i<strlen(stri);i++)
	{
		WriteUART(stri[i]);
	}
}

void UARTHandle()
{
	int data;
	data = ReadUART();
	UARTString("Cortex-M0 : ");
	WriteUART(data);
	WriteUART('\r');
    WriteUART('\n');
}
