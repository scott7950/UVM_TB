`ifndef __CPU_MONITOR_SV__
`define __CPU_MONITOR_SV__

`include "cpu_interface.svi"
`include "cpu_transaction.sv"

//typedef class cpu_monitor;

//class cpu_monitor_cbs extends uvm_callback;
//  virtual function void trans_observed(cpu_monitor xactor, cpu_transaction cycle);
//  endfunction
//endclass

class cpu_monitor extends uvm_monitor;

virtual cpu_interface cpu_vif;

bit checks_enable = 1;
bit coverage_enable = 1;

uvm_analysis_port #(cpu_transaction) item_collected_port;

`uvm_component_utils_begin(cpu_monitor)
  `uvm_field_int(checks_enable, UVM_DEFAULT)
  `uvm_field_int(coverage_enable, UVM_DEFAULT)
`uvm_component_utils_end

function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual cpu_interface)::get(this, "", "cpu_vif", cpu_vif)) begin
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ", get_full_name(), ".cpu_vif"});
    end

endfunction

virtual protected task collect_transactions();
    @(posedge cpu_vif.rst_n);

    forever begin
        cpu_transaction cpu_tr = new();

        do begin
            @(cpu_vif.cb);
        end while(cpu_vif.enable == 1'b0);

        cpu_tr.din  = cpu_vif.din;
        cpu_tr.addr = cpu_vif.addr;
        if(cpu_vif.rw == 1'b0) begin
            cpu_tr.rw   = cpu_transaction::WRITE;
        end
        else begin
            cpu_tr.rw   = cpu_transaction::READ;
        end
        cpu_tr.dout = cpu_vif.dout;

        //`uvm_do_callbacks(cpu_monitor, cpu_monitor_cbs, trans_observed(this,cpu_tr))
        item_collected_port.write(cpu_tr);
    end
endtask
  
virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_full_name(),$sformatf(" CPU Monitor"), UVM_MEDIUM)

    fork
        collect_transactions();
    join
endtask

virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
endfunction

endclass

`endif

