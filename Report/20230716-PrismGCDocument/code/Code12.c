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