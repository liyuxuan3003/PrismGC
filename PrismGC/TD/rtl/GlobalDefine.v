`ifndef GLOBAL_DEFINE_V
`define GLOBAL_DEFINE_V

`define CLK_FRE 50000000

`define DEVICES_EXP 4

`define RAM_DATA_WIDTH 15        //2^15 Bytes
`define RAM_CODE_WIDTH 16        //2^16 Bytes

`define SDRAM_WIDTH    23        //2^23 Bytes

`define   DATA_WIDTH   32
`define   DM_WIDTH     4

`define   ROW_WIDTH    11
`define   BA_WIDTH     2

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

`define	H_FRONT	12'd24
`define	H_SYNC 	12'd136  
`define	H_BACK 	12'd160  
`define	H_DISP 	12'd1024
`define	H_TOTAL	12'd1344
				
`define	V_FRONT	12'd3
`define	V_SYNC 	12'd6 
`define	V_BACK 	12'd29  
`define	V_DISP 	12'd600  
`define	V_TOTAL	12'd638

`define VRAM_BUFF 64

`endif