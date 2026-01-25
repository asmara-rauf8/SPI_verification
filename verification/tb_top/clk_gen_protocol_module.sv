////////////////////////////////////////////////////////////////////////////////
//
// Filename : clk_gen_protocol_module.sv
// Author : Asmara Rauf
// Creation Date : 16/12/2024
//
// No portions of this material may be reproduced in any form without
// the written permission of CoMira solutions Inc.
//
// All information contained in this document is CoMira solutions
// private, proprietary and trade secret.
//
// Description
// ===========
// This module contains protocol module used for the generation of clock for SPI module. 
//
// ///////////////////////////////////////////////////////////////////////////////


module clk_gen_protocol_module
 #(
   //string INTERFACE,
   parameter int BAUD_RATE,
   parameter int BAUD_DIVISOR
  )
  (
    input logic miso,
    output logic ss,
    output logic sclk,
    output logic mosi
  );
  
  logic clk_pm;
  real clk_freq;
  real clk_period;
  real delay;
  int pol;
  int pha;
    
  import uvm_pkg::*;
  import pkg::*;

  initial begin
    clk_freq = BAUD_RATE * BAUD_DIVISOR;
    clk_period = (1e6/clk_freq);
    delay = (clk_period/2);

    @(posedge clk_pm);
    if (!uvm_config_db #(int)::get(null, "*", "polarity", pol)) begin
      `uvm_fatal("TOP","unable to get Polarity")
    end
    
    if (!uvm_config_db #(int)::get(null, "*", "phase", pha)) begin
      `uvm_fatal("TOP","unable to get Phases")
    end
  end
  
  spi_intf        pif();
  master_clk_intf pif_clk();
  
  // clock generation 
  initial begin
    clk_pm <= 0; 
    forever #(delay) clk_pm <= ~clk_pm;   
  end   
  
  always @(clk_pm) begin
    if (pif.ss == 0) begin
      if (pol == pha) begin
        pif.sclk <= clk_pm;
      end
      else begin
        pif.sclk <= ~clk_pm;
      end
    end
    else begin
      pif.sclk <= pol;      
    end
  end

  assign pif_clk.clk = clk_pm;
  assign ss = pif.ss;
  assign mosi = pif.mosi;
  assign pif.miso = miso;
  assign sclk = pif.sclk;
  
  // set interface in config db
  initial begin
    uvm_config_db #(virtual spi_intf)::set(null,"uvm_test_top.env.m_agent","vif",pif);
  end

  initial begin
    uvm_config_db #(virtual master_clk_intf)::set(null,"uvm_test_top.env.m_agent.master_drv","vif_clk",pif_clk);
  end
endmodule

