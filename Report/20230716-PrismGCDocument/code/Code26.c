int NunchuckKey(void)
{
	int key=0;
	struct NunchuckData d;
	NunchuckRead(&d);
	if(d.bz)
	{
		if(d.ax<450 && d.ax<d.ay)
			key='L';
		else if(d.ax>650 && d.ax>d.ay)
			key='R';
		else if(d.ay<450)
			key='D';
		else if(d.ay>650 )
			key='U';
	}
	else
	{
		if(d.sx<64 && d.sx<d.sy )
			key='L';
		else if(d.sx>192 && d.sx>d.sy )
			key='R';
		else if(d.sy<64 )
			key='D';
		else if(d.sy>192 )
			key='U';
	}
    if(d.bc)
    {
        key='C';
        DBG("d.az=%d\n",d.az);
    }   
	return key;	
}