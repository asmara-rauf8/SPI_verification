////////////////////////////////////////////////////////////////////////////////
//
// Filename : sanity_test.sv
// Author : Asmara Rauf
// Creation Date : 11/15/2024
//
// Description
// ===========
// This module contains test cases for the verification of SPI, extended from uvm_test base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class sanity_test extends uvm_test;

  `uvm_component_utils(sanity_test)

  // constructor
  function new(string name="sanity_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  // declarations
  tx_seq         m_seq;
  tx_seq         s_seq;
  ss_high_seq    ss_high;
  spi_env        env;
  env_config     cfg;

  // build phase
  function void build_phase(uvm_phase phase);
    env     = spi_env::type_id::create("env",this);
    m_seq   = tx_seq::type_id::create("m_seq",this);
    s_seq   = tx_seq::type_id::create("s_seq",this);
    ss_high = ss_high_seq::type_id::create("ss_high",this);
    cfg     = env_config::type_id::create("cfg",this);
    
    cfg.m_cfg.polarity = $urandom_range(0,1); 
    cfg.m_cfg.phase    = $urandom_range(0,1);
        
    uvm_config_db #(env_config)::set(this, "env", "cfg", cfg);
    uvm_config_db #(int)::set(null, "*", "pol", cfg.m_cfg.polarity);
    uvm_config_db #(int)::set(null, "*", "pha", cfg.m_cfg.phase);
    
  endfunction
  
  // run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    
    repeat(5) begin
      ss_high.start(env.m_agent.sqr); 
    end
    repeat(2) begin
      fork
        master_tx();
        slave_tx();
      join
      repeat(5) begin
        ss_high.start(env.m_agent.sqr); 
      end
    end
    #100;
    phase.drop_objection(this);
  endtask
  
  task master_tx();
    m_seq.start(env.m_agent.sqr); 
  endtask
  
  task slave_tx();
    s_seq.start(env.s_agent.sqr); 
  endtask
  
endclass

