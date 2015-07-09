`ifndef __PACKET_AGENT_SV__
`define __PACKET_AGENT_SV__

`include "packet_sequencer.sv"
`include "packet_driver.sv"
`include "packet_monitor.sv"

class packet_agent extends uvm_agent;
packet_sequencer pkt_sqr;
packet_driver    pkt_drv;
packet_monitor   pkt_mon;

`uvm_component_utils_begin(packet_agent)
    `uvm_field_object(pkt_sqr, UVM_ALL_ON)
    `uvm_field_object(pkt_drv, UVM_ALL_ON)
    `uvm_field_object(pkt_mon, UVM_ALL_ON)
`uvm_component_utils_end

function new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    pkt_sqr = packet_sequencer::type_id::create("pkt_sqr", this);
    pkt_drv = packet_driver::type_id::create("pkt_drv", this);
    pkt_mon = packet_monitor::type_id::create("pkt_mon", this);
    
endfunction

virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    pkt_drv.seq_item_port.connect(pkt_sqr.seq_item_export);
endfunction

endclass

`endif

