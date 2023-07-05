#include "Font16.h"
#include "Font.h"
#include "Console.h"
#include <stdlib.h>

const struct Font *GetFontGlyph(unsigned short int ch)
{
    const struct Font *font=NULL;
    for(int i=0;i<sizeof(font16)/sizeof(struct Font);i++)
    {
        if(ch==font16[i].index)
        {
            font =&font16[i];
            break;
        }
    }
    if(font==NULL)
        printf("ch=%d not found\r\n",(int)ch);
    return font;

    // int left=0;
    // int right=0;
    // int middle;
    // unsigned int middle_value;

    // right=sizeof(font16)/sizeof(struct Font) - 2;
    // while(left<=right)
    // {
    //     middle=(left+right)/2;
    //     middle_value=font16[middle].index;
    //     if(ch<middle_value)
    //         right=middle-1;
    //     else if(ch>middle_value)
    //         left=middle+1;
    //     else
    //         break;
    // }
    // return &font16[middle];
}

