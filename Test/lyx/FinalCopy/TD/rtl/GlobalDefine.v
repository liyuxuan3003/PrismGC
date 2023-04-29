`ifndef GLOBAL_DEFINE_V
`define GLOBAL_DEFINE_V

`define DEVICES_EXP 4

`define idRAMCode       0
`define idRAMData       1
`define idGPIO          2
`define idUART          3
`define idHDMI          4

`define M(loc,w) (loc+1)*w-1:loc*w

`endif