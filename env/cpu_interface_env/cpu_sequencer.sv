`ifndef __CPU_SEQUENCER_SV__
`define __CPU_SEQUENCER_SV__

`include "cpu_transaction.sv"

class cpu_sequencer extends uvm_sequencer #(cpu_transaction);

`uvm_component_utils(cpu_sequencer)

function new(string name, uvm_component parent=null);
    super.new(name, parent);
endfunction

endclass

`endif

