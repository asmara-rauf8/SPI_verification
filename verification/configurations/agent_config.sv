////////////////////////////////////////////////////////////////////////////////
//
// Filename : agent_config.sv
// Author : Asmara Rauf
// Creation Date : 12/06/2024
//
// Description
// ===========
// This module contains SPI master and slave agents configuration extended from uvm_object.
//
// ///////////////////////////////////////////////////////////////////////////////

class agent_config extends uvm_object;    
 
  //factory registration 
  `uvm_object_utils(agent_config)
  
  //declarations
  int polarity; 
  int phase;
  
  // constructor
  function new(string name = "agent_config");
    super.new(name);    
  endfunction
  
endclass
