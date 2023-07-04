#ifndef FONT_H
#define FONT_H

struct Font
{
	unsigned short width:6;
	unsigned short height:6;
	unsigned short bpp:4;
	unsigned short int index;
	const unsigned char *pixels;
};

const struct Font *GetFontGlyph(unsigned short int ch);

#endif

