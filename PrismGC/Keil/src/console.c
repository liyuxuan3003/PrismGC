/*
* Copyright (c) 2023 by Liyuxuan,all rights reserved
*/

#include "UART.h"
#include "Interrupt.h"
#include "Console.h"

#define NO_TXINT

#ifndef CON_RECV_MAX
	#define CON_RECV_MAX   32
#endif
#ifndef CON_SEND_MAX
	#define CON_SEND_MAX   64
#endif

static volatile unsigned char CON_recvBuf[CON_RECV_MAX];
static volatile unsigned char CON_sendBuf[CON_SEND_MAX];
static volatile int CON_recvHead;
static volatile int CON_recvTail;
static volatile int CON_sendHead;
static volatile int CON_sendTail;
static volatile int CON_recvOk;
static volatile int CON_sendOk;

static void CON_rx_ie(int enable)
{
		NVIC_CTRL_ADDR = enable;
}

static char CON_rx()
{
    char data = UART -> RX_DATA;
    return data;
}

static void CON_tx_ie(int enable)
{
		(void)enable;
}

static void CON_tx(char data)
{
	UART -> TX_DATA = data;
}

static void CON_tx_wait(char data)
{
    while(UARTReadState());
	//while(UART -> TX_STATE);
	UART -> TX_DATA = data;
    //while(UART -> TX_STATE);
}

void UARTHandle()
//static void CON_rxInt(void)
{
	static int esc;
	unsigned char dat = CON_rx();
	if(dat=='\r'||dat=='\n')
	{
		CON_tx_wait('\r');
		CON_tx_wait('\n');
		CON_recvBuf[CON_recvTail]=dat;
		CON_recvTail++;
		if(CON_recvTail>=CON_RECV_MAX)
			CON_recvTail=0;
		CON_recvOk=1;
	}
	else if(dat=='\b'||dat==0x7f)
	{
		esc=0;
		if(CON_recvTail!=CON_recvHead)
		{
			CON_tx_wait('\b');
			CON_tx_wait(' ');
			CON_tx_wait('\b');
			CON_recvTail--;
			if(CON_recvTail<0)
				CON_recvTail=CON_RECV_MAX-1;
		}
	}
	else if(dat=='\x1b')
	{
		esc=1;
	}
	else if(dat>=0x20)
	{
		if(esc)
		{
			esc=0;
			dat=0;
		}
		if(esc==0 && dat)
		{
			int j=CON_recvTail;
			j++;
			if(j>=CON_RECV_MAX)
				j=0;
			if(j==CON_recvHead)
				dat = '\x07';
			CON_tx_wait(dat);

			if(j!=CON_recvHead)
			{
				CON_recvBuf[CON_recvTail]=dat;
				CON_recvTail++;
				if(CON_recvTail>=CON_RECV_MAX)
					CON_recvTail=0;
			}
		}
	}
}

static void CON_txInt(void)
{
	if(CON_sendHead!=CON_sendTail)
	{
		unsigned char dat=CON_sendBuf[CON_sendHead];
		CON_sendHead++;
		if(CON_sendHead>=CON_SEND_MAX)
			CON_sendHead=0;
		CON_tx(dat);
	}
	else
	{
		CON_sendOk=1;
		CON_tx_ie(0);
	}
}

void conInit(int port,int32_t baud)
{
	CON_recvOk=0;
	CON_sendOk=1;
	//CON_init(port,baud);
}

int conReadData(char *pData,int size)
{
	uint8_t i=0;
	pData[0]='\0';
	CON_rx_ie(0);
	if(CON_recvOk)
	{
		CON_recvOk=0;
		for(i=0; i<size; i++)
		{
			if(CON_recvHead!=CON_recvTail)
			{
				pData[i]=CON_recvBuf[CON_recvHead];
				CON_recvHead++;
				if(CON_recvHead>=CON_RECV_MAX)
					CON_recvHead=0;
				if(pData[i]=='\r'||pData[i]=='\n')
				{
					pData[i]='\0';
					break;
				}
			}
			else
				break;
		}
		i++;
	}
	CON_rx_ie(1);
	return i;
}

#ifdef NO_TXINT	
static void conWaitSendByte(unsigned char c)
{
	if(c=='\n')
		CON_tx_wait('\r');
	CON_tx_wait(c);
}
#else
static void conTxStart(void)
{
	if(CON_sendOk)
	{
		char dat=CON_sendBuf[CON_sendHead];
		CON_sendHead++;
		if(CON_sendHead>=CON_SEND_MAX)
			CON_sendHead=0;
		CON_tx_wait(dat);
		CON_sendOk=0;
	}
	CON_tx_ie(1);
}

static void conSendByte(unsigned char c)
{
	if(c=='\n')
	{
		CON_sendBuf[CON_sendTail]='\r';
		CON_sendTail++;
		if(CON_sendTail>=CON_SEND_MAX)
			CON_sendTail=0;
		if(CON_sendTail==CON_sendHead)
		{
			CON_sendHead=0;
			CON_sendBuf[0]='\r';
			CON_sendTail=1;
		}
	}
	CON_sendBuf[CON_sendTail]=c;
	CON_sendTail++;
	if(CON_sendTail>=CON_SEND_MAX)
		CON_sendTail=0;
	if(CON_sendTail==CON_sendHead)
	{
		CON_sendHead=0;
		if(c=='\n')
		{
			CON_sendBuf[0]='\r';
			CON_sendBuf[1]='\n';
			CON_sendTail=2;
		}
		else
		{
			CON_sendBuf[0]=c;
			CON_sendTail=1;
		}
	}
}
#endif

int conPrintf(const char *fmt,...)
{
	va_list va;
	uint8_t val;
	CON_tx_ie(0);
	va_start(va, fmt);
#ifdef NO_TXINT	
	val=_xprint(conWaitSendByte,fmt,va);
    va_end(va);
#else	
	val=_xprint(conSendByte,fmt,va);
	va_end(va);
	if(CON_sendHead!=CON_sendTail)
	{
		conTxStart();
	}
#endif	
	return val;
}

