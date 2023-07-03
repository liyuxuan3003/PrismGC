#include "Nunchuck.h"

#include "HardwareConfig.h"
#include "Sleep.h"

#define T_SU_STA    4700    // START condition setup time  
#define T_HD_STA    5600    // START condition hold time
#define T_LOW       6000    // SCL low time
#define T_HIGH      4200    // SCL high time
#define T_HD_DAT    3000    // Data-in hold time
#define T_SU_DAT    3000    // Data-in setup time
#define T_SU_STO    6000    // STOP condition setup time 

#define I2C_WR    0
#define I2C_RD    1

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
}

static inline uint8_t BitIn()
{
    SCL(L);
    ndelay(T_SU_DAT);
    uint8_t bit;
    if(SDA(P))
        bit=1;
    else
        bit=0;
    ndelay(T_LOW-T_SU_DAT);
    SCL(H);
    ndelay(T_HIGH);
    return bit;
}

static inline void I2CSetSlave(uint8_t slave,uint8_t rw)
{
	SCL(O);
	SCL(H);

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
	SDA(O);
	for(int i=0;i<8;i++)
	{
        BitOut(b&0x80);
        b <<= 1;
	}
    SDA(I);
    BitIn();
}

static inline uint8_t I2CRead()
{
    SDA(I);

	uint8_t b=0;
	for(int i=0;i<8;i++)
	{
        b |= BitIn();
		b<<=1;
	}

    BitIn();

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
	I2CSetSlave(0x52,I2C_WR);
	I2CWrite(0x40);
	I2CWrite(0x00);
	I2CStop();
    udelay(500);
    return 0;
}

int NunchuckRead(struct NunchuckData *d)
{
	I2CSetSlave(0x52,I2C_WR);
	I2CWrite(0x00);
	I2CStop();

    //udelay(500);
	udelay(20);
	I2CSetSlave(0x52,I2C_RD);
    //udelay(10);
	d->sx=I2CRead();
    //udelay(10);
	d->sy=I2CRead();
	d->ax=I2CRead();
	d->ay=I2CRead();
	d->az=I2CRead();
	uint8_t b5=I2CRead();
	I2CStop();

	d->ax = (d->ax<<2) | ((b5>>6)&0x03);
	d->ay = (d->ay<<2) | ((b5>>4)&0x03);
	d->az = (d->az<<2) | ((b5>>2)&0x03);
	d->bc = (b5&0x02)!=0;
	d->bz = b5&0x01;

	return 0;
}

