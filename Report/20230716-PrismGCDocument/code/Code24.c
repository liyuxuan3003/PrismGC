#define I2C_WR    0
#define I2C_RD    1

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