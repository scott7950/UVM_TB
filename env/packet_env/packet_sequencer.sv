`ifndef __PACKET_SEQUENCER_SV__
`define __PACKET_SEQUENCER_SV__

`include "packet_transaction.sv"

class packet_sequencer extends uvm_sequencer #(packet_transaction);

`uvm_component_utils(packet_sequencer)

function new(string name, uvm_component parent=null);
    super.new(name, parent);
endfunction

endclass

`endif

