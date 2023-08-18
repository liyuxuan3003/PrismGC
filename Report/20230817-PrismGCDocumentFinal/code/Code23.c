#define T_SU_STA    4700    // START condition setup time  
#define T_HD_STA    5600    // START condition hold time
#define T_LOW       6000    // SCL low time
#define T_HIGH      4000    // SCL high time
#define T_HD_DAT    3000    // Data-in hold time
#define T_SU_DAT    3000    // Data-in setup time
#define T_SU_STO    6000    // STOP condition setup time 

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
