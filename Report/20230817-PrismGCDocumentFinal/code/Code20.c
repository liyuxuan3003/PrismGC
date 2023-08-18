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
    uint32_t offset=0;

    while(offset<len)
    {
        uint32_t x = (x_pos + offset) % 1024;
        uint32_t y = (x_pos + offset) / 1024 + y_pos;
        uint32_t lenNow = (len-offset<128) ? len-offset : 128;
        
        for(uint32_t xDeath=256;xDeath<=256*3;xDeath+=256)
        {
            if(x < xDeath && x+lenNow > xDeath)
            {
                lenNow = xDeath - x;
                break;
            }
        }

        GPU -> X_POS = x;
        GPU -> Y_POS = y;
        GPU -> PIXEL = pixel;
        GPU -> LEN = lenNow;
        GPU -> SYS_WR_LEN = (lenNow <= 8) ? lenNow : 8;
        GPU -> ENABLE = 1;
        __asm("nop");
        __asm("nop");
        while(GPUBusy()) ;
        ndelay(800);
        GPU -> ENABLE = 0;

        offset += lenNow;
    }
}
