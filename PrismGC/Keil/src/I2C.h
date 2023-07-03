#ifndef I2C_H
#define I2C_H

#define T_CLK       20

#define T_SU_STA    4700    // START condition setup time  
#define T_HD_STA    4000    // START condition hold time
#define T_LOW       4700    // SCL low time
#define T_HIGH      4000    // SCL high time
#define T_HD_DAT    300     // Data-in hold time
#define T_SU_DAT    250     // Data-in setup time,
#define T_SU_STO    4000    // STOP condition setup time 

void I2C();

#endif