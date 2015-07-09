`ifndef __CPU_AGENT_SV__
`define __CPU_AGENT_SV__

`include "cpu_sequencer.sv"
`include "cpu_driver.sv"
`include "cpu_monitor.sv"

class cpu_agent extends uvm_agent;
cpu_sequencer  cpu_sqr;
cpu_driver     cpu_drv;
cpu_monitor    cpu_mon;

`uvm_component_utils_begin(cpu_agent)
    `uvm_field_object(cpu_sqr, UVM_ALL_ON)
    `uvm_field_object(cpu_drv, UVM_ALL_ON)
    `uvm_field_object(cpu_mon, UVM_ALL_ON)
`uvm_component_utils_end

function new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cpu_sqr = cpu_sequencer::type_id::create("cpu_sqr", this);
    cpu_drv = cpu_driver::type_id::create("cpu_drv", this);
    cpu_mon = cpu_monitor::type_id::create("cpu_mon", this);

endfunction

virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    cpu_drv.seq_item_port.connect(cpu_sqr.seq_item_export);
endfunction

endclass

`endif

