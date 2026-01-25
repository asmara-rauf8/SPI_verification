////////////////////////////////////////////////////////////////////////////////
//
// Filename : mosi_monitor.sv
// Author : Asmara Rauf
// Creation Date : 11/13/2024
//
// Description
// ===========
// This module contains monitor that monitors SPI mosi signal extended from uvm_monitor base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class mosi_monitor extends uvm_monitor;

  // factory registration
  `uvm_component_utils(mosi_monitor)

  //constructor
  function new(string name="mosi_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction

  // declarations
  tx  txx_mosi;
  virtual spi_intf  vif;
  agent_config   cfg;

  bit cpol;
  bit cpha;
  
  uvm_analysis_port  #(tx) mosi_monitor_analysis_port;  

  // build_phase
  function void build_phase(uvm_phase phase);
    if (!(uvm_config_db #(virtual spi_intf)::get(this,"","vif",vif))) begin
      `uvm_fatal("monitor","unable to get interface")
    end
    
    txx_mosi = tx ::type_id::create("txx_mosi",this);   
    cfg      = agent_config::type_id::create("cfg",this);
    
    mosi_monitor_analysis_port = new("mosi_monitor_analysis_port",this);
    
    if (!uvm_config_db#(agent_config)::get(this, "", "cfg", cfg)) begin
      `uvm_error("MOSI MONITOR", "Failed to get agent_config from config DB")
    end
    cpol = cfg.polarity; 
    cpha = cfg.phase; 
  endfunction

  // run_phase
  task run_phase(uvm_phase phase);
    forever begin          
      if (vif.ss == 0) begin
        receive_data();
      end
      if (cpol == 0) begin
        @(posedge vif.sclk);
      end 
      else begin
        @(negedge vif.sclk);
      end 
    end 
  endtask
  
  
  task receive_data();
    case (cpha)
      1'b0: begin
        for (int i=0; i<DATA_WIDTH; i++) begin 
          txx_mosi.data[i] = vif.mosi;
          if (cpol == 1'b0) begin
            @(posedge vif.sclk);
          end
          else begin
            @(negedge vif.sclk);
          end  
        end 
      end
      1'b1: begin
        for (int i=0; i<DATA_WIDTH; i++) begin
          txx_mosi.data[i] = vif.mosi;
          if (cpol == 1'b1) begin
            @(negedge vif.sclk);
          end
          else begin
            @(posedge vif.sclk);
          end
        end 
      end
    endcase
    `uvm_info("txx mosi", $sformatf("%0d",txx_mosi.data), UVM_LOW)
    mosi_monitor_analysis_port.write(txx_mosi);
  endtask
  
endclass

