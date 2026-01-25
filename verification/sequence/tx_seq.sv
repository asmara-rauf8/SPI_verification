////////////////////////////////////////////////////////////////////////////////
//
// Filename : tx_seq.sv
// Author : Asmara Rauf
// Creation Date : 11/12/2024
//
// Description
// ===========
// This module contains data sequence for simulation extended from uvm_sequence base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class tx_seq extends uvm_sequence #(tx);

  // factory registration
  `uvm_object_utils(tx_seq)

  // constructor
  function new(string name="tx_seq");
    super.new(name);
  endfunction

  // declarations
  tx  txn;
  
  // main task of the sequence
  virtual task body();
    txn  = tx::type_id::create("txn");
    start_item(txn);
    txn.data_pkt();
    finish_item(txn); 
  endtask

endclass

