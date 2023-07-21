void LCDBackground(uint32_t color)
{
    RamWrite(0,0,color,H_DISP*V_DISP);
}

void LCDRectangle(uint32_t color,uint32_t x1,uint32_t y1,uint32_t x2,uint32_t y2)
{
    uint32_t len=x2-x1;
    for(uint32_t y=y1;y<=y2;y++)
    {
        RamWrite(x1,y,color,len);
    }
}

void LCDPixel(uint32_t color,uint32_t x,uint32_t y)
{
    RamWrite(x,y,color,1);
}