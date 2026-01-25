////////////////////////////////////////////////////////////////////////////////
//
// Filename : slave_protocol_module.sv
// Author : Asmara Rauf
// Creation Date : 16/12/2024
//
// Description
// ===========
// This module contains protocol module used for the generation of clock for SPI module. 
//
// ///////////////////////////////////////////////////////////////////////////////


module slave_protocol_module
  (
    input logic ss,
    input logic sclk,
    input logic mosi,
    output logic miso
  );
  
  import uvm_pkg::*;
  
  spi_intf  pif();

  assign pif.sclk = sclk;
  assign pif.ss = ss;
  assign pif.mosi = mosi;
  assign miso = pif.miso;
  
  // set interface in config db
  initial begin
    uvm_config_db #(virtual spi_intf)::set(null,"uvm_test_top.env.s_agent","vif",pif);    
  end

endmodule

