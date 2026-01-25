////////////////////////////////////////////////////////////////////////////////
//
// Filename : slave_driver.sv
// Author : Asmara Rauf
// Creation Date : 11/13/2024
//
// Description
// ===========
// This module contains SPI slave driver extended from uvm_driver base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class slave_driver extends uvm_driver #(tx);

  //factory registration
  `uvm_component_utils(slave_driver)

  //constructor
  function new(string name="slave_driver",uvm_component parent);
    super.new(name,parent);
  endfunction

  //declarations
  virtual spi_intf  vif;
  tx  txn;
  agent_config  cfg;
  bit cpol;
  bit cpha;

  //build phase
  function void build_phase(uvm_phase phase);
    cfg = agent_config::type_id::create("cfg",this);
    
    if (!(uvm_config_db #(virtual spi_intf)::get(this,"","vif",vif))) begin
      `uvm_fatal("SLAVE DRIVER","unable to get interface")
    end
    
    if (!uvm_config_db#(agent_config)::get(this, "", "cfg", cfg)) begin
      `uvm_error("SLAVE DRIVER", "Failed to get agent_config from config DB")
    end
    cpol = cfg.polarity; 
    cpha = cfg.phase;
  endfunction

  //run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);    
    forever begin
      seq_item_port.get_next_item(txn); 
      if (cpol == 0) begin
        @(posedge vif.sclk);
      end 
      else begin
        @(negedge vif.sclk);
      end    
      if (vif.ss == 0) begin 
        data_transfer();
      end
      seq_item_port.item_done();  
    end
  endtask
  
  // Data transmission
  task data_transfer();
    case ({cpol, cpha})
      2'b00: begin
        for (int j=0; j<DATA_WIDTH; j++) begin
          @(negedge vif.sclk);
          vif.miso <= txn.data[j];
        end 
      end
      
      2'b01: begin
        for (int j=0; j<DATA_WIDTH; j++) begin
          vif.miso <= txn.data[j];
          @(posedge vif.sclk);
        end 
      end
      
      2'b10: begin
        for (int j=0; j<DATA_WIDTH; j++) begin
          @(posedge vif.sclk);
          vif.miso <= txn.data[j];
        end 
      end      
      
      2'b11: begin
        for (int j=0; j<DATA_WIDTH; j++) begin
          vif.miso <= txn.data[j];
          @(negedge vif.sclk);
        end 
      end
    endcase

  endtask
    
endclass









