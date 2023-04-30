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

// `define     VGA_640_480_60FPS_25MHz
// `define     VGA_640_480_75FPS_31MHz
// `define     VGA_800_600_60FPS_40MHz
`define	  VGA_1024_600_60FPS_50MHz

//---------------------------------
//    640 * 480     25MHz   
`ifdef      VGA_640_480_60FPS_25MHz
`define     H_FRONT     12'd16
`define     H_SYNC      12'd96  
`define     H_BACK      12'd48  
`define     H_DISP      12'd640 
`define     H_TOTAL     12'd800     
                    
`define     V_FRONT     12'd10  
`define     V_SYNC      12'd2   
`define     V_BACK      12'd33 
`define     V_DISP      12'd480   
`define     V_TOTAL     12'd525
`endif

//---------------------------------
//    640 * 480     31MHz
`ifdef      VGA_640_480_75FPS_31MHz
`define     H_FRONT     12'd16
`define     H_SYNC      12'd64
`define     H_BACK      12'd120
`define     H_DISP      12'd640 
`define     H_TOTAL     12'd840     
                    
`define     V_FRONT     12'd1  
`define     V_SYNC      12'd3   
`define     V_BACK      12'd16
`define     V_DISP      12'd480   
`define     V_TOTAL     12'd500
`endif

//---------------------------------
//    800 * 600     40MHz
`ifdef VGA_800_600_60FPS_40MHz 
`define     H_FRONT     12'd40
`define     H_SYNC      12'd128  
`define     H_BACK      12'd88  
`define     H_DISP      12'd800
`define     H_TOTAL     12'd1056 
                        
`define     V_FRONT     12'd1 
`define     V_SYNC      12'd4   
`define     V_BACK      12'd23  
`define     V_DISP      12'd600  
`define     V_TOTAL     12'd628
`endif

//---------------------------------
//	1024 * 600      50MHz
`ifdef      VGA_1024_600_60FPS_50MHz
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
`endif

`endif