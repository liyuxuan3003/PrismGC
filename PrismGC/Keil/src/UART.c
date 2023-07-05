#include <string.h>

#include "UART.h"
 
char UARTReadState()
{
    char stat = UART -> TX_STATE;
    return stat;
}

char UARTRead()
{
    char data = UART -> RX_DATA;
    return data;
}

void UARTWrite(char data)
{
    while(UARTReadState());
	UART -> TX_DATA = data;
}

void UARTString(char *stri)
{
	for(int i=0;i<strlen(stri);i++)
		UARTWrite(stri[i]);
}
/*
void UARTHandle()
{
	int data = UARTRead();
    if(data=='\r')
        UARTWrite('\n');
	UARTWrite(data);
}
*/