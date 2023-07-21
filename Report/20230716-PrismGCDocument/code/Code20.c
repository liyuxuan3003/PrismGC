void WaitRamReady()
{
    while(!GPU -> SYS_VAILD) ;
    GPU -> PING_PONG = 0x0;         //0M
}

void PingPong()
{
    GPU -> PING_PONG = !GPU -> PING_PONG;
}

static void RamWrite(uint32_t x_pos,uint32_t y_pos,uint32_t pixel,uint32_t len)
{
    GPU -> X_POS = x_pos;
    GPU -> Y_POS = y_pos;
    GPU -> PIXEL = pixel;
    GPU -> LEN = len;
    GPU -> SYS_WR_LEN = (len <= 8) ? len : 8;
    GPU -> ENABLE = 1;
    __asm("nop");
    __asm("nop");
    while(GPU -> BUSY) ;
    ndelay(1000);
    GPU -> ENABLE = 0;
}