////////////////////////////////////////////////////////////////////////////////
//
// Filename : spi_scb.sv
// Author : Asmara Rauf
// Creation Date : 11/15/2024
//
// Description
// ===========
// This module contains SPI scoreboard extended from uvm_scb base component.
//
// ///////////////////////////////////////////////////////////////////////////////


`uvm_analysis_imp_decl(_mosi_rx_monitor)
`uvm_analysis_imp_decl(_miso_rx_monitor)

class spi_scb extends uvm_scoreboard;

  //factory registration
  `uvm_component_utils(spi_scb)

  //constructor
  function new(string name="spi_scb",uvm_component parent);
    super.new(name,parent);
  endfunction

  //declarations
  tx  item;
  uvm_tlm_analysis_fifo #(tx) mosi_tx_analysis_fifo;
  uvm_tlm_analysis_fifo #(tx) miso_tx_analysis_fifo;
  uvm_tlm_analysis_fifo #(tx) mosi_rx_analysis_fifo;
  uvm_tlm_analysis_fifo #(tx) miso_rx_analysis_fifo;

  int   total_monitored;
  int   pass;
  int   fail;
  logic [DATA_WIDTH-1:0] mosi_tx;
  logic [DATA_WIDTH-1:0] miso_tx;
  logic [DATA_WIDTH-1:0] mosi_rx;
  logic [DATA_WIDTH-1:0] miso_rx;


  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mosi_tx_analysis_fifo = new("mosi_tx_analysis_fifo", this);
    mosi_rx_analysis_fifo = new("mosi_rx_analysis_fifo", this);
    miso_tx_analysis_fifo = new("miso_tx_analysis_fifo", this);
    miso_rx_analysis_fifo = new("miso_rx_analysis_fifo", this);
    total_monitored = 0;
    pass = 0;
    fail = 0;
  endfunction 
  
  task run_phase(uvm_phase  phase);
    forever begin 
      #10;   
      if (mosi_tx_analysis_fifo.used() > 0) begin
        mosi_tx_analysis_fifo.get(item); 
        mosi_tx = item.data;
      end
      if (mosi_rx_analysis_fifo.used() > 0) begin
        mosi_rx_analysis_fifo.get(item); 
        mosi_rx = item.data;
        comparison_mosi();
      end
      
      if (miso_tx_analysis_fifo.used() > 0) begin
        miso_tx_analysis_fifo.get(item); 
        miso_tx = item.data;
      end
      if (miso_rx_analysis_fifo.used() > 0) begin
        miso_rx_analysis_fifo.get(item); 
        miso_rx = item.data;
        comparison_miso();
      end
    end
  endtask
  
  //mosi data received by slave
  task comparison_mosi();
    total_monitored++;
      if (mosi_tx == mosi_rx) begin
        pass++;
      end
      else begin
        fail++;
      end
      prints(); 
  endtask
  
  task comparison_miso();
    total_monitored++;
      if (miso_tx == miso_rx) begin
        pass++;
      end
      else begin
        fail++;
      end
      prints(); 
  endtask
  
  
  function prints();
    `uvm_info("RESULTS", $sformatf("======================="), UVM_LOW)
    `uvm_info("RESULTS", $sformatf("TOTAL PASS       = %0d", pass), UVM_LOW)
    `uvm_info("RESULTS", $sformatf("TOTAL FAIL       = %0d", fail), UVM_LOW)
    `uvm_info("RESULTS", $sformatf("TOTAL MONITORED  = %0d", total_monitored), UVM_LOW)
    `uvm_info("RESULTS", $sformatf("======================="), UVM_LOW)
  endfunction
endclass
