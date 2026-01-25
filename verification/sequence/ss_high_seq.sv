////////////////////////////////////////////////////////////////////////////////
//
// Filename : ss_high_seq.sv
// Author : Asmara Rauf
// Creation Date : 31/12/2024
//
// Description
// ===========
// This module contains data sequence for simulation extended from uvm_sequence base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class ss_high_seq extends uvm_sequence #(tx);

  // factory registration
  `uvm_object_utils(ss_high_seq)

  // constructor
  function new(string name="ss_high_seq");
    super.new(name);
  endfunction

  // declarations
  tx  txn;
  
  // main task of the sequence
  virtual task body();
    txn  = tx::type_id::create("txn");
    start_item(txn);
    txn.invalid_pkt();
    finish_item(txn); 
  endtask

endclass

