////////////////////////////////////////////////////////////////////////////////
//
// Filename : env_config.sv
// Author : Asmara Rauf
// Creation Date : 12/06/2024
//
// Description
// ===========
// This module contains SPI environment configuration extended from uvm_object.
//
// ///////////////////////////////////////////////////////////////////////////////

class env_config extends uvm_object;
 
  //factory registration 
  `uvm_object_utils(env_config)
  
  // declarations  
  agent_config m_cfg;
  agent_config s_cfg;
  
  // constructor
  function new(string name = "env_config");
    super.new(name);
    m_cfg = agent_config::type_id::create("m_cfg");
    s_cfg = agent_config::type_id::create("s_cfg"); 
  endfunction
  
endclass

