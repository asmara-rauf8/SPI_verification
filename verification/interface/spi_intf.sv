////////////////////////////////////////////////////////////////////////////////
//
// Filename : spi_intf.sv
// Author : Asmara Rauf
// Creation Date : 11/12/2024
//
// Description
// ===========
// This module contains interface through which driver communicates wuth dut and dut communicates with monitor.
//
// ///////////////////////////////////////////////////////////////////////////////

interface spi_intf;
	
  logic    sclk;
  logic    miso;
  logic    mosi;
  logic    ss;
  
endinterface

