/*
 * Copyright (c) 2023 by LLoong,all rights reserved
 */
/**
 * @file
 * @brief GamePad font struct
 * @author Li zhuoyi(li@lloong.cn)
 *
 * @date 2023-02-06 初始版本
 *
 **/

#ifndef _FONT_H
#define _FONT_H

struct Font
{
	unsigned short width:6;
	unsigned short height:6;
	unsigned short bpp:4;
	unsigned short int index;
	const unsigned char *pixels;
};

const struct Font * get_fontglyph(unsigned short int ch);

#endif

