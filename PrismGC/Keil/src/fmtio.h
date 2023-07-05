/**
*FileName   : fmtio.h
*Description:
*Refence doc:
**/

#ifndef _FMTIO_H
#define _FMTIO_H

#include <stdint.h>
#include <stdarg.h>

#ifdef __AVR_ARCH__
	#define FLASH  const __flash
	#define _N(s) (__extension__({ __attribute__((__progmem__)) static const char __c[] = (s); &__c[0];}))
#else
	#define FLASH  const
	#define _N(s)  s
#endif

int _xprint(void (*_put) (unsigned char), const char * fmt, va_list va);
int _xscan (unsigned char (*_get) (void), const char * fmt, va_list va);

int _sprint(char *strbuf,const char *const fmt,...);
int _sscan (char *strbuf,const char *const fmt,...);

#endif

