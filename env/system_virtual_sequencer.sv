`ifndef __SYSTEM_VIRTUAL_SEQUENCER_SV__
`define __SYSTEM_VIRTUAL_SEQUENCER_SV__

`include "cpu_sequencer.sv"
`include "packet_sequencer.sv"

class system_virtual_sequencer extends uvm_sequencer;
cpu_sequencer    cpu_sqr;
packet_sequencer pkt_sqr;

`uvm_component_utils(system_virtual_sequencer)

function new (string name="system_virtual_sequencer", uvm_component parent=null);
    super.new(name, parent);
endfunction

endclass

`endif

