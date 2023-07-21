int NunchuckInit()
{
	I2CSetSlave(0x52,I2C_WR);
	I2CWrite(0x40);
	I2CWrite(0x00);
	I2CStop();
    return 0;
}

struct NunchuckData
{
	uint8_t sx;
	uint8_t sy;
	uint16_t ax;
	uint16_t ay;
	uint16_t az;
	uint8_t bc;
	uint8_t bz;
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

	return 0;
}