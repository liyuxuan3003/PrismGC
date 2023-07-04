/*
 * Copyright (c) 2023 by Liyuxuan,all rights reserved
 */

#include "font16.h"
#include "font.h"

const struct Font * get_fontglyph(unsigned short int ch)
{
    int left=0;
	int right=0;
	int middle;
	unsigned int middle_value;

    right=sizeof(font16)/sizeof(struct Font) - 2;
	while(left<=right)
	{
		middle=(left+right)/2;
		middle_value=font16[middle].index;
		if(ch<middle_value)
			right=middle-1;
		else if(ch>middle_value)
			left=middle+1;
		else
		{
			break;
		}
	}
	return &font16[middle];
}

