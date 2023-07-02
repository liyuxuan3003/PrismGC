#include <stdint.h>
#include "code_def.h"
#include <string.h>
#include <stdio.h>

extern uint32_t key_flag;
int __main()
{
	NVIC_CTRL_ADDR=1;

while(1)
{	while(!key_flag);
uint32_t din;
din=Keyboard_keydata_clear;

int i=0;
int ans=0;
for(i=0;i<16;i++)
{
	if((din>>i)&1)
{
	ans=i;
	Music_data=16+ans;
	break;
}
}
key_flag=0;
Keyboard_keydata_clear=1;

}
}
