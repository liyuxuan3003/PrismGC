#ifndef FONT_H
#define FONT_H

struct Font
{
	unsigned char width;
	unsigned char height;
	unsigned char bpp;
	unsigned short int index;
	const unsigned char *pixels;
};

const struct Font *GetFontGlyph(unsigned short int ch);

#endif

