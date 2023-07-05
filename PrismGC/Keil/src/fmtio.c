/**
*FileName   : fmtio.c
*Description:
*Refence doc:
**/

/**
HISTORY:
 V0.01    2001.07.01     creation
 V0.02    2001.09.12     add xscan and modify xprint
                         xprint needn't ltoa function
 V0.03    2003.03.05     add %tu support
                         modify %w.d
                         w width(include dot)
                         d decimal width
 V0.04    2003.11.10     modify xscan %u %d great than 65535 error
 V0.05    2010.05.10     replace multy byte by utf-8
 V0.06    2018.04.06     support MC96F8316(sdcc)
 V0.07    2018.12.24     support avr-gcc __flash
 V0.08    2018.12.24     support long long
**/

#include <stdint.h>
#include <stdarg.h>
#include "fmtio.h"

//#if __SIZEOF_INT__ >=4 && !defined(FMT_NO_LONGLONG)
//	#define FMT_LONGLONG
//#endif

#define F_LONGLONG  0x01
#define F_LONG      0x02
#define F_LEFTALIGN 0x04
#define F_ADDSIGN   0x08
#define F_ZEROPADD  0x10
#define F_ADDDOT    0x20
#define F_DONE      0x40
#define F_SHORT     0x80

#ifdef FMT_LONGLONG
	#define BUFLEN  32
#else
	#define BUFLEN  16
#endif

int _xprint (void (*_put) (unsigned char), const char * fmti, va_list va)
{
	FLASH char *fmt=fmti;
	int8_t ret = 0;

	char c;
	char *s;
#ifdef FMT_LONGLONG
	long long l;
	unsigned long long ul;
#else
	long l;
	unsigned long ul;
#endif

	char signch;
	uint8_t flags;
	int8_t width;
	int8_t prec;
	int8_t decimal;

	int8_t i;
	int8_t len;
	char buf[BUFLEN+1];

	for ( ; *fmt; fmt++)
	{
		if (*fmt == '\t' )
		{
			(*_put) (' ');
			ret++;
			continue;
		}
		else if (*fmt != '%' )
		{
			(*_put) (*fmt);
			ret++;
			continue;
		}
		fmt++;
		if (*fmt=='%')
		{
			(*_put) ('%');
			ret++;
			continue;
		}
		else if (*fmt=='t')
		{
			(*_put) ('\t');
			ret++;
			continue;
		}
		//check flag characters: '-','+',' ','#'
		// '-' Left-justifies the result, pads on the right with blanks.
		//     If not given, right-justifies result, pads on left with zeros or blanks.
		// '+' Signed conversion results always begin with a plus (+) or minus (-) sign.
		// ' ' If value is non-negative, the output begins with a blank instead of a plus;
		//     negative values still begin with a minus.
		// '#' IGNORE
		// '0' filled on the left with zeros
		flags = 0;
		signch = ' ';
		for (flags&=~F_DONE; ; fmt++)
		{
			switch (*fmt)
			{
			case '-':
				flags |= F_LEFTALIGN;
				break;
			case '+':
				flags |= F_ADDSIGN;
				signch = '+';
				break;
			case ' ':
				flags |= F_ADDSIGN;
				signch = ' ';
				break;
			case '#':
				break;
			case '0':
				flags |= F_ZEROPADD;
				break;
			default:
				flags |= F_DONE;
				break;
			}
			if (flags&F_DONE)
				break;
		}

		// read the 'width' , 'precision' and 'decimal' fields
		width=0;
		if (*fmt>='0'&&*fmt<='9')
		{
			width=*fmt-'0';
			fmt++;
		}
		if (*fmt>='0'&&*fmt<='9')
		{
			width*=10;
			width+=*fmt-'0';
			fmt++;
		}

		prec=0;
		decimal=0;
		if (*fmt == '.')
		{
			fmt++;
			decimal =*fmt;
			decimal-='0';
			fmt++;
			if (*fmt>='0'&&*fmt<='9')
			{
				prec=*fmt-'0';
				fmt++;
			}
			else
				prec=decimal;
			if (prec)
				flags|=F_ADDDOT;
		}
		if (prec>decimal)
			prec=decimal;

		if (*fmt == 'l')
		{
			fmt++;
			if(*fmt == 'l')
			{
				fmt++;
				flags |= F_LONGLONG;
			}
			else
				flags |= F_LONG;
		}
		else if (*fmt == 'n')
		{
			fmt++;
			flags |= F_SHORT;
		}

		// look for the base conversion type
		switch (*fmt)
		{
		case 'f':
			(*_put) ('f');
			ret++;
			break;
		case 'c':
			c = va_arg (va, int);
			(*_put) (c);
			ret++;
			break;
		case 's':
			s = va_arg (va, char *);
			while (s && *s)
			{
				(*_put)(*s++);
				ret++;
			}
			break;
		case 'd':
		case 'u':
		case 'o':
		case 'x':
		case 'X':
		case 'b':
			if (flags & F_LONG)
				l = va_arg (va, long);
			else if (flags & F_LONGLONG)
				l = va_arg (va, long long);
			else
				l = va_arg (va,int);
			if (l < 0 && *fmt=='d')
			{
				flags |= F_ADDSIGN;
				signch = '-';
				ul = -l;
			}
			else
				ul = l;

			len=0;
			buf[BUFLEN]='\0';
			s=&buf[BUFLEN];
			while (ul)
			{
				if((*fmt == 'x') ||( *fmt == 'X'))
				{
					c = ul & 0x0f;
					ul>>=4;
				}
				else if(*fmt == 'o')
				{
					c = ul & 0x07;
					ul>>=3;
				}
				else if(*fmt == 'b')
				{
					c = ul & 0x01;
					ul>>=1;
				}
				else
				{
					c = ul % 10;
					ul /= 10;
				}
				if(c<=9)
					*--s = c + '0';
				else
					*--s = c + *fmt + ('A'-10-'X');
				len++;
			}
			if (len==0)
			{
				len=1;
				*--s='0';
			}
			if (len>decimal)
				width =width-len+decimal-prec;
			else
				width=width-prec-1;
			if (flags & F_ADDSIGN)
				width--;
			if (flags & F_ADDDOT)
				width--;

			if (flags & F_ZEROPADD)        //zero padded
			{
				if (flags & F_ADDSIGN)
				{
					(*_put) ( signch);
					ret++;
				}
				if (!(flags & F_LEFTALIGN))
				{
					while (width > 0)
					{
						(*_put) ( '0');
						width--;
						ret++;
					}
				}
			}
			else                           // space padded
			{
				if (!(flags & F_LEFTALIGN))
				{
					while (width > 0)
					{
						(*_put) ( ' ');
						width--;
						ret++;
					}
				}
				if (flags & F_ADDSIGN)
				{
					(*_put) ( signch);
					ret++;
				}
			}

			// now put the actual string
			i=len-decimal;
			if (i<=0)
			{
				(*_put) ( '0');
				ret++;
			}
			for (; i>0; i--)
			{
				(*_put)(*s++);
				ret++;
			}
			if (flags&F_ADDDOT)
			{
				(*_put) ( '.');
				ret++;
				for (; i<0; i++)
				{
					(*_put) ( '0');
					ret++;
					prec--;
				}
				while ( prec--)
				{
					(*_put) ( *s++);
					ret++;
				}
			}
			// then pad if necessary
			if (flags & F_LEFTALIGN)
			{
				while (width > 0)
				{
					(*_put) ( ' ');
					width--;
					ret++;
				}
			}
			break;
		default:
			(*_put) ( *fmt);
			ret++;
			break;
		}
	}
	return ret;
}

#ifdef USE_SPRINT
static char *strPutPtr;
static void strPut(unsigned char c)
{
	*strPutPtr=c;
	strPutPtr++;
}

int _sprint(char *strbuf,const char *fmt,...)
{
	va_list va;
	uint8_t val;
	strPutPtr=strbuf;
	va_start(va, fmt);
	val=_xprint(strPut,fmt,va);
	va_end(va);
	strPut('\0');
	return val;
}
#endif

#ifdef USE_XSCAN
int _xscan (unsigned char (*_get) (void), const char * fmt, va_list va)
{
	int8_t ret = 0;

	char c=0;
	uint8_t flags=0;
	int8_t width;
	int8_t decimal;
	int8_t uminus;

	long l=0;
	unsigned char *p;

	for ( ; *fmt; fmt++)
	{
		flags=0;
		if (*fmt != '%')
		{
			(*_get)();
			ret++;
			continue;
		}
		fmt++;
		width=9;
		decimal=0;
		uminus=0;
		if (*fmt=='-')
			fmt++;
		if (*fmt=='+')
			fmt++;
		if (*fmt=='0')
			fmt++;
		if (*fmt>='0'&&*fmt<='9')
		{
			width=*fmt-'0';
			fmt++;
		}
		if (*fmt=='.')
		{
			fmt++;
			if (*fmt>='0'&&*fmt<='9')
			{
				decimal=*fmt-'0';
				fmt++;
				if (*fmt>='0'&&*fmt<='9')
					fmt++;
			}
		}
		if (*fmt=='l')
		{
			fmt++;
			flags |= F_LONG;
		}
		switch (*fmt)
		{
		case 'c':
			*(unsigned char *)va_arg (va, char *)=(*_get) ();
			ret++;
			break;
		case 'd':
		case 'u':
			for (l=0; width; width--)
			{
				c = (*_get)();
				ret++;
				if (c>='0'&&c<='9')
				{
					l=(l<<3)+(l<<1);
					l += ( long )( c & 0xf );
				}
				else if (c == '-')
				{
					uminus = 1;
					width++;
				}
				else if (c == '+')
					width++;
				else
					break;
			}
			if (c=='.')
			{
				for (; decimal; decimal--)
				{
					c = (*_get)();
					ret++;
					if (c>='0'&&c<='9')
					{
						l=(l<<3)+(l<<1);
						l += ( long )( c & 0xf );
					}
					else if (c=='.')
						decimal++;
					else
						break;
				}
			}
			for (; decimal; decimal--)
				l=(l<<3)+(l<<1);
			if (uminus)
				l=-l;
			if (flags&F_LONG)
			{
				*(unsigned long *)va_arg (va, unsigned long *)=l;
			}
			else
			{
				if (l>65535)
					l=65535;
				*(unsigned short *)va_arg (va, unsigned short *)=(unsigned short)l;
			}
			break;
		case 'b':
		case 'B':
			for (l=0; width; width--)
			{
				c = (*_get)();
				ret++;
				if (c=='0'||c=='1')
				{
					l<<=1;
					if (c=='1')
						l+= 1;
				}
				else
					break;
			}
			if (flags&F_LONG)
			{
				*(unsigned long *)va_arg (va, unsigned long *)=l;
			}
			else
			{
				*(unsigned int *)va_arg (va, unsigned int *)=(unsigned int)l;
			}
			break;
		case 'x':
		case 'X':
			for (l=0; width; width--)
			{
				c = (*_get)();

				if (c == 0)
				{
					break;
				}
				ret++;
				l<<=4;
				if ((c>='0'&&c<='9') )
					l+= ( long )( c - '0' );
				else if ((c>='a'&&c<='f'))
					l+= ( long )( c - 'a' + 10 );
				else if ((c>='A'&&c<='F'))
					l += ( long )( c - 'A' + 10 );
				else
				{
					l>>=4;
					break;
				}
			}
			if (flags&F_LONG)
			{
				*(unsigned long *)va_arg (va, unsigned long *)=l;
			}
			else
			{
				*(unsigned short int *)va_arg (va, unsigned short int *)=(unsigned short int)l;
			}
			break;
		case 's':
			p=(unsigned char *)va_arg (va, char *);
			while (1)
			{
				c = (*_get)();
				ret++;
				if (c==' '||c=='\0')
				{
					*p=0;
					break;
				}
				else
				{
					*p=c;
					p++;
				}
			}
			break;
		default:
			ret++;
			break;
		}
	}
	return ret;
}
#endif

#ifdef USE_SSCAN
static char *strGetPtr;
static unsigned char strGet(void)
{
	unsigned char c;
	c=*strGetPtr;
	strGetPtr++;
	return c;
}

int _sscan(char *strbuf,const char *fmt,...)
{
	va_list va;
	uint8_t val;
	strGetPtr=strbuf;
	va_start(va, fmt);
	val=_xscan(strGet,fmt,va);
	va_end(va);
	return val;
}
#endif

