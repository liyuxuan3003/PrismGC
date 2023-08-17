#include "Nunchuck.h"

#include "HardwareConfig.h"
#include "Sleep.h"

#include "Console.h"

#define T_SU_STA    4700    // START condition setup time  
#define T_HD_STA    5600    // START condition hold time
#define T_LOW       6000    // SCL low time
#define T_HIGH      4000    // SCL high time
#define T_HD_DAT    3000    // Data-in hold time
#define T_SU_DAT    3000    // Data-in setup time
#define T_SU_STO    6000    // STOP condition setup time 

#define I2C_WR    0
#define I2C_RD    1

// #define DEBUG_NUNCHUCK

#ifdef DEBUG_NUNCHUCK
	#define DBG printf
#else
	#define DBG(x,...) __asm("nop")
#endif
#define NUNCHUK_ENABLE_ENCRYPTION

static int isNunchuckReady=0;

static inline void BitOut(uint8_t bit)
{
    SCL(L);
    ndelay(T_HD_DAT);
    if(bit)
        SDA(H);
    else
        SDA(L);
    ndelay(T_LOW-T_HD_DAT);
    SCL(H);
    ndelay(T_HIGH);
    SCL(L);
}

static inline uint8_t BitIn()
{
    SCL(L);
    ndelay(T_LOW);
    uint8_t bit;
    if(SDA(P))
        bit=1;
    else
        bit=0;
    SCL(H);
    ndelay(T_HIGH);
    SCL(L);
    return bit;
}

static inline void I2CSetSlave(uint8_t slave,uint8_t rw)
{
	ndelay(T_LOW);
	SCL(O);
	SCL(H);
	ndelay(T_HIGH);

	SDA(O);
	SDA(L);
	
	ndelay(T_HD_STA);

	for(int i=0;i<7;i++)
	{
        BitOut(slave & 0x40);
        slave <<= 1;
	}

    BitOut(rw);

    SDA(I);
    BitIn();
}
		
static inline void I2CWrite(uint8_t b)
{
	SCL(O);
	SDA(O);
	for(int i=0;i<8;i++)
	{
        BitOut(b&0x80);
        b <<= 1;
	}
    SDA(I);
    BitIn();
}

static inline uint8_t I2CRead(uint8_t ack)
{
    ndelay(T_HD_DAT);
    SDA(I);

	uint8_t b=0;
	for(int i=0;i<8;i++)
	{
		b<<=1;
        b |= BitIn();
	}

	SDA(O);
    BitOut(ack);
#ifdef NUNCHUK_ENABLE_ENCRYPTION
	// b = (b^0x17) + 0x17;
#endif
    return b;
}

static inline void I2CStop()
{
    SCL(L);
    ndelay(T_LOW);

	SDA(O);
	SDA(L);

    ndelay(T_HD_DAT);

	SCL(O);
	SCL(H);
	ndelay(T_SU_STO);
	SDA(H);
    ndelay(T_HIGH);
}

int NunchuckInit()
{
#ifdef NUNCHUK_ENABLE_ENCRYPTION
	I2CSetSlave(0x52,I2C_WR);
	I2CWrite(0x40);
	I2CWrite(0x00);
	I2CStop();
#else
	I2CSetSlave(0x52,I2C_WR);
	I2CWrite(0xF0);
	I2CWrite(0x55);
	I2CStop();
	I2CSetSlave(0x52,I2C_WR);
	I2CWrite(0xFB);
	I2CWrite(0x00);
	I2CStop();
#endif	
	uint32_t id=NunchuckID();
	if((id&0xffff)==0x20a4)
    {
        isNunchuckReady=0;
        return 0;
    }
	else
    {
        isNunchuckReady=-1;
        return -1;
    }
}

uint32_t NunchuckID(void)
{
	I2CSetSlave(0x52,I2C_WR);
	I2CWrite(0xFA);
	I2CStop();

	uint8_t buf[6];
	I2CSetSlave(0x52,I2C_RD);
	for(int i=0;i<5;i++)
		buf[i]=I2CRead(0);
	buf[5]=I2CRead(1);
	I2CStop();

	DBG("ID: %02x,%02x,%02x,%02x,%02x,%02x\n",
		buf[0],buf[1],buf[2],buf[3],buf[4],buf[5]);

	return *(uint32_t *)&buf[2];
};

void NunchuckReadCal(void)
{
	I2CSetSlave(0x52,I2C_WR);
	I2CWrite(0x20);
	I2CStop();

	uint8_t buf[16];
	I2CSetSlave(0x52,I2C_RD);
	for(int i=0;i<15;i++)
		buf[i]=I2CRead(0);
	buf[15]=I2CRead(1);
	I2CStop();

	printf("CAL: ");
	for(int i=0;i<16;i++)
		printf("%02x ",buf[i]);
	printf("\n");
};

int NunchuckRead(struct NunchuckData *d)
{
	I2CSetSlave(0x52,I2C_WR);
	I2CWrite(0x00);
	I2CStop();

	I2CSetSlave(0x52,I2C_RD);
	d->sx=I2CRead(0);
	d->sy=I2CRead(0);
	d->ax=I2CRead(0);
	d->ay=I2CRead(0);
	d->az=I2CRead(0);
	uint8_t b5=I2CRead(1);
	I2CStop();
	
	d->ax = (d->ax<<2) | ((b5>>6)&0x03);
	d->ay = (d->ay<<2) | ((b5>>4)&0x03);
	d->az = (d->az<<2) | ((b5>>2)&0x03);
	d->bc = (~b5>>1)&0x01;
	d->bz = ~b5&0x01;

	DBG("sx=%d,sy=%d\n",d->sx,d->sy);
	DBG("ax=%d,ay=%d,az=%d\n",d->ax,d->ay,d->az);
	DBG("bc=%d,bz=%d\n",d->bc,d->bz);
	return 0;
}

int NunchuckKey(uint8_t buttonZ)
{
	int key=0;
	struct NunchuckData d;
	NunchuckRead(&d);
	if(d.bz)
	{
        if(buttonZ)
            key='E';
		else if(d.ax<450 && d.ax<d.ay)
		{
			key='L';
			DBG("<,d.ax=%d,d.ay=%d\n",d.ax,d.ay);
		}
		else if(d.ax>650 && d.ax>d.ay)
		{
			key='R';
			DBG(">,d.ax=%d,d.ay=%d\n",d.ax,d.ay);
		}
		else if(d.ay<450)
		{
			key='D';
			DBG("v,d.ax=%d,d.ay=%d\n",d.ax,d.ay);
		}
		else if(d.ay>650 )
		{
			key='U';
			DBG("^,d.ax=%d,d.ay=%d\n",d.ax,d.ay);
		}
	}
	else
	{
		if(d.sx<64 && d.sx<d.sy )
		{
			key='L';
			DBG("<,d.sx=%d,d.sy=%d\n",d.sx,d.sy);
		}
		else if(d.sx>192 && d.sx>d.sy )
		{
			key='R';
			DBG(">,d.sx=%d,d.sy=%d\n",d.sx,d.sy);
		}
		else if(d.sy<64 )
		{
			key='D';
			DBG("v,d.sx=%d,d.sy=%d\n",d.sx,d.sy);
		}
		else if(d.sy>192 )
		{
			key='U';
			DBG("v,d.sx=%d,d.sy=%d\n",d.sx,d.sy);
		}
	}
    if(d.bc)
    {
        key='C';
        DBG("d.az=%d\n",d.az);
    }   
	return key;	
}

int IsNumchuckReady()
{
    return isNunchuckReady;
}