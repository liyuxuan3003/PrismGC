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