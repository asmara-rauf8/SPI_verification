////////////////////////////////////////////////////////////////////////////////
//
// Filename : slave_agent.sv
// Author : Asmara Rauf
// Creation Date : 11/12/2024
//
// Description
// ===========
// This module contains SPI slave agent extended from uvm_agent base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class slave_agent extends uvm_agent;

  //factory registration
  `uvm_component_utils(slave_agent)

  //constructor
  function new (string name="slave_agent",uvm_component parent);
    super.new (name,parent);
  endfunction

  //declarations
  slave_driver   slave_drv;
  uvm_sequencer  #(tx) sqr;
  miso_monitor   slave_mon_tx;
  mosi_monitor   slave_mon_rx;
  agent_config   cfg;
  virtual spi_intf  vif;
  //build phase
  function void build_phase(uvm_phase phase);
    sqr          = uvm_sequencer#(tx)::type_id::create("sqr",this);
    cfg          = agent_config::type_id::create("cfg",this);
    slave_drv    = slave_driver::type_id::create("slave_drv",this);
    slave_mon_tx = miso_monitor::type_id::create("slave_mon_tx",this);
    slave_mon_rx = mosi_monitor::type_id::create("slave_mon_rx",this);
    
    if (!uvm_config_db #(agent_config)::get(this, "" , "cfg", cfg)) begin
      `uvm_error("SLAVE AGENT", "Unable to get configuration object")
    end
    if (!(uvm_config_db #(virtual spi_intf)::get(this,"","vif",vif))) begin
      `uvm_fatal("SLAVE AGENT","unable to get interface")
    end
    

    uvm_config_db #(virtual spi_intf)::set(this, "slave_drv", "vif", vif);
    uvm_config_db #(virtual spi_intf)::set(this, "slave_mon_tx", "vif", vif);
    uvm_config_db #(virtual spi_intf)::set(this, "slave_mon_rx", "vif", vif);
    
    uvm_config_db #(agent_config)::set(this, "slave_drv", "cfg", cfg);
    uvm_config_db #(agent_config)::set(this, "slave_mon_tx", "cfg", cfg);
    uvm_config_db #(agent_config)::set(this, "slave_mon_rx", "cfg", cfg);
  endfunction

  // connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_warning("SLAVE AGENT","Starting connect phase")
    slave_drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction

endclass

