`ifndef GLOBAL_DEFINE_V
`define GLOBAL_DEFINE_V

`define DEVICES_EXP 4

`define RAM_DATA_WIDTH 14        //2^14 Bytes
`define RAM_CODE_WIDTH 14        //2^14 Bytes

`define idRAMCode           0
`define idRAMData           1
`define idSDRAM             2
`define idTimer             3
`define idGPIO              4
`define idUART              5
`define idIIC               6
`define idGPULite           7
`define idHDMI              8
`define idBuzzer            9
`define idDigit             10
`define idKeyBoard          11
`define idMAX               12

`define addrRAMCode         16'h0000
`define addrRAMData         16'h2000
`define addrSDRAM           16'h4000
`define addrTimer           16'h6001
`define addrGPIO            16'h6002
`define addrUART            16'h6003
`define addrIIC             16'h6004
`define addrGPULite         16'h6005
`define addrHDMI            16'h6006
`define addrBuzzer          16'h6007
`define addrDigit           16'h6008
`define addrKeyBoard        16'h6009

`endif