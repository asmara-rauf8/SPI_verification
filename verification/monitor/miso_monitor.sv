////////////////////////////////////////////////////////////////////////////////
//
// Filename : miso_monitor.sv
// Author : Asmara Rauf
// Creation Date : 11/13/2024
//
// Description
// ===========
// This module contains monitor that monitors SPI miso signal, extended from uvm_monitor base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class miso_monitor extends uvm_monitor;

  // factory registration
  `uvm_component_utils(miso_monitor)

  //constructor
  function new(string name="miso_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction

  // declarations
  tx   txx_miso; 
  virtual spi_intf  vif;
  agent_config  cfg;

  bit cpol;
  bit cpha;
  
  uvm_analysis_port #(tx) miso_monitor_analysis_port;

  // build_phase
  function void build_phase(uvm_phase phase);
    if (!(uvm_config_db #(virtual spi_intf)::get(this,"","vif",vif))) begin
      `uvm_fatal("monitor","unable to get interface")
    end
    
    txx_miso = tx ::type_id::create("txx_miso",this);   
    cfg      = agent_config::type_id::create("cfg",this);
    
    miso_monitor_analysis_port  = new("miso_monitor_analysis_port",this);

    if (!uvm_config_db#(agent_config)::get(this, "", "cfg", cfg)) begin
      `uvm_error("MISO MONITOR", "Failed to get env_config from config DB")
    end
    cpol = cfg.polarity; 
    cpha = cfg.phase; 
  endfunction

  // run_phase
  task run_phase(uvm_phase phase);    
    forever begin 
      if (cpol == cpha) begin
        @(negedge vif.sclk);
      end 
      else begin
        @(posedge vif.sclk);
      end
      if (vif.ss == 0) begin
        receive_data();
      end
    end
  endtask
  
  
  task receive_data();
    case ({cpol, cpha})
      2'b00, 2'b11: begin
        for (int i=0; i<DATA_WIDTH; i++) begin
          @(negedge vif.sclk);
          txx_miso.data[i] = vif.miso;     
        end 
      end
      2'b01, 2'b10: begin
        for (int i=0; i<DATA_WIDTH; i++) begin
          @(posedge vif.sclk);
          txx_miso.data[i] = vif.miso;        
        end 
      end
    endcase
    `uvm_info("txx miso", $sformatf("%0d at time: %0t",txx_miso.data,$time), UVM_LOW)
    miso_monitor_analysis_port.write(txx_miso);
  endtask
  
endclass

