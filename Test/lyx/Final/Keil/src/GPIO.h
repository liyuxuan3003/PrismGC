#ifndef GPIO_H
#define GPIO_H

//oData
#define R     +0)&              //R-Register    获取输出寄存器上的指定位的值
#define L     +0)&=~            //L-Low         设置输出寄存器上的指定位为0 输出低电平
#define H     +0)|=             //H-High        设置输出寄存器上的指定位为1 输出高电平
#define V     +0)^=             //V-Reverse     翻转输出寄存器上的指定位

//iData
#define P     +1)&              //P-Pin         获取输入寄存器上的指定位的值

//oEnable
#define I     +2)&=~            //I-Input       设置输出使能寄存器上的指定位为0 设置其为输入
#define O     +2)|=             //O-Output      设置输出使能寄存器上的指定位为1 设置其为输出

#endif