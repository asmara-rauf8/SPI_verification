////////////////////////////////////////////////////////////////////////////////
//
// Filename : tx.sv
// Author : Asmara Rauf
// Creation Date : 11/12/2024
//
// Description
// ===========
// This module contains SPI transactions extended from uvm_sequence_item base component.
//
// ///////////////////////////////////////////////////////////////////////////////

class tx extends uvm_sequence_item;
  
  // constructor
  function new(string name="tx");
    super.new(name);
  endfunction

  // declarations  
  bit [DATA_WIDTH-1:0] data;
  bit ss;
  
  // factory registration & field macros
  `uvm_object_utils_begin(tx)
  `uvm_field_int(data, UVM_ALL_ON)
  `uvm_field_int(ss, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // data packet
  function invalid_pkt(); 
    ss   = 1;
    data = 0;
  endfunction
  
  
  function data_pkt(); 
    ss   = 0;
    data = $random();
  endfunction
  
endclass

