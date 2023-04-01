///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            
//   Filename : eg_phy_glbl.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module glbl();
reg done_gwe, gsr, gsrn;
reg usr_gsrn_en;
initial
 begin
  done_gwe=0;
  gsr=1;
  gsrn=0;
  usr_gsrn_en=0;
#10;
  done_gwe=1;
  //gsr=0;
  //gsrn=1;
end

always @(*)
begin
  if (!usr_gsrn_en) begin
    #10 gsr <= 0;
    #10 gsrn <= 1;
  end
end

endmodule    
