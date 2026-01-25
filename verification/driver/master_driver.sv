////////////////////////////////////////////////////////////////////////////////
//
// Filename : master_driver.sv
// Author : Asmara Rauf
// Creation Date : 11/13/2024
//
// Description
// ===========
// This module contains SPI master driver extended from uvm_driver base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class master_driver extends uvm_driver #(tx);

  //factory registration
  `uvm_component_utils(master_driver)

  //constructor
  function new(string name="master_driver",uvm_component parent);
    super.new(name,parent);
  endfunction

  //declarations
  virtual spi_intf  vif;
  virtual master_clk_intf m_intf;
  tx  txn;
  agent_config cfg;

  bit cpol;
  bit cpha;

  //build phase
  function void build_phase(uvm_phase phase);
    cfg = agent_config::type_id::create("cfg",this);
    
    if (!(uvm_config_db #(virtual spi_intf)::get(this,"","vif",vif))) begin
      `uvm_fatal("DRIVER","unable to get interface")
    end
    
    if (!(uvm_config_db #(virtual master_clk_intf)::get(this,"","vif_clk",m_intf))) begin
      `uvm_fatal("DRIVER","unable to get interface")
    end
    
    if (!uvm_config_db#(agent_config)::get(this, "", "cfg", cfg)) begin
      `uvm_error("MASTER DRIVER", "Failed to get agent_config from config DB")
    end
    cpol = cfg.polarity; 
    cpha = cfg.phase; 
  endfunction

  //run phase  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);  
    //vif.ss <= 1; 
    $display("master drv pol: %0d, pha: %0d",cpol,cpha);  
    forever begin
      seq_item_port.get_next_item(txn);
      vif.ss <= txn.ss;
      if (txn.ss == 0) begin
        data_transfer(); 
      end
      if (cpol == 0) begin
        @(posedge m_intf.clk);
      end 
      else begin
        @(negedge m_intf.clk);
      end
      seq_item_port.item_done();
    end
  endtask

  //Clock and Data Transmission
  task data_transfer();    
    case (cpol)
      1'b0: begin
        for (int j=0; j<DATA_WIDTH; j++) begin
          if (cpha == 0) begin
            @(posedge m_intf.clk);  
            vif.mosi <= txn.data[j];
          end
          else begin 
            vif.mosi <= txn.data[j];  
            @(posedge m_intf.clk);                  
          end
        end 
      end
      1'b1: begin
        for (int j=0; j<DATA_WIDTH; j++) begin
          if (cpha == 0) begin
            @(posedge m_intf.clk);  
            vif.mosi <= txn.data[j];
          end
          else begin 
            @(posedge m_intf.clk);    
            vif.mosi <= txn.data[j];  
          end
        end 
      end
    endcase
  endtask
    
endclass









