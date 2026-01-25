////////////////////////////////////////////////////////////////////////////////
//
// Filename : spi_env.sv
// Author : Asmara Rauf
// Creation Date : 11/12/2024
//
// Description
// ===========
// This module contains SPI environment extended from uvm_env base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class spi_env extends uvm_env;
  
  //factory registration 
  `uvm_component_utils(spi_env)

  //constructor
  function new(string name="spi_env",uvm_component parent);
    super.new(name,parent);
  endfunction

  //declarations
  master_agent  m_agent; 
  slave_agent   s_agent;
  spi_scb       scb;
  env_config    cfg;

  // build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_agent = master_agent::type_id::create("m_agent",this);
    s_agent = slave_agent::type_id::create("s_agent",this);
    scb     = spi_scb::type_id::create("scb",this);
    cfg     = env_config::type_id::create("cfg",this);
    
    if (!uvm_config_db#(env_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("ENVIRONMENT", "Failed to get env_config from config DB")
    end
    
    cfg.s_cfg.polarity = cfg.m_cfg.polarity; 
    cfg.s_cfg.phase    = cfg.m_cfg.phase;  
    
    uvm_config_db #(agent_config)::set(this, "m_agent", "cfg", cfg.m_cfg);
    uvm_config_db #(agent_config)::set(this, "s_agent", "cfg", cfg.s_cfg);
  endfunction

  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);   
    m_agent.master_mon_tx.mosi_monitor_analysis_port.connect(scb.mosi_tx_analysis_fifo.analysis_export);
    s_agent.slave_mon_tx.miso_monitor_analysis_port.connect(scb.miso_tx_analysis_fifo.analysis_export);
    s_agent.slave_mon_rx.mosi_monitor_analysis_port.connect(scb.mosi_rx_analysis_fifo.analysis_export);
    m_agent.master_mon_rx.miso_monitor_analysis_port.connect(scb.miso_rx_analysis_fifo.analysis_export);
  endfunction

endclass
