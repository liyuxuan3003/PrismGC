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

void LCDCircle(uint32_t color,int32_t x,int32_t y,int32_t r,int32_t pix)
{
    for(int32_t i=-r;i<=+r;i+=pix)
    {
        LCDRectangle(
            color,
            x-(int32_t)sqrt(r*r-i*i),
            y+i-(pix-1),
            x+(int32_t)sqrt(r*r-i*i),
            y+i);
    }
}

void LCDPixel(uint32_t color,uint32_t x,uint32_t y)
{
    RamWrite(x,y,color,1);
}