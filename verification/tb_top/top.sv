////////////////////////////////////////////////////////////////////////////////
//
// Filename : top.sv
// Author : Asmara Rauf
// Creation Date : 11/12/2024
//
// Description
// ===========
// This module is the top testbench module used for the verification of SPI module. 
//
// ///////////////////////////////////////////////////////////////////////////////
module top;

  import uvm_pkg::*;
  import pkg::*;
  
  logic miso,mosi,ss,sclk;
  
  // protocol module for clock generation
  master_protocol_module #(
    .BAUD_RATE(BAUD_RATE),
    .BAUD_DIVISOR(BAUD_DIVISOR)
   )
   clk_module(
     .miso(miso),
     .ss(ss),
     .mosi(mosi),
     .sclk(sclk)
   );

  slave_protocol_module slv_module(
     .miso(miso),
     .ss(ss),
     .mosi(mosi),
     .sclk(sclk)
   );

  // run test
  initial begin
    run_test();
  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;
  end

endmodule

