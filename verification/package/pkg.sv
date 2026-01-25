////////////////////////////////////////////////////////////////////////////////
//
// Filename : pkg.sv
// Author : Asmara Rauf
// Creation Date : 11/12/2024
//
// Description
// ===========
// This module is a package file which contains all the required components for the verification of SPI, macros and uvm package.
//
// ///////////////////////////////////////////////////////////////////////////////

package pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "../parameter/parameter.sv"
  `include "../configurations/agent_config.sv"
  `include "../configurations/env_config.sv"   
  `include "../sequence_item/tx.sv"  
  `include "../sequence/tx_seq.sv" 
  `include "../sequence/ss_high_seq.sv" 
  `include "../driver/master_driver.sv"  
  `include "../driver/slave_driver.sv"  
  `include "../monitor/miso_monitor.sv"
  `include "../monitor/mosi_monitor.sv"  
  `include "../agent/master_agent.sv"
  `include "../agent/slave_agent.sv" 
  `include "../scoreboard/spi_scb.sv"   
  `include "../environment/spi_env.sv" 
  `include "../test/sanity_test.sv"
endpackage : pkg
