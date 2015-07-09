`ifndef _CPU_BASE_SEQUENCE_SV__
`define _CPU_BASE_SEQUENCE_SV__

virtual class cpu_base_sequence extends uvm_sequence #(cpu_transaction);

function new(string name="cpu_base_sequence");
    super.new(name);
    set_automatic_phase_objection(1);
endfunction
  
endclass

class read_word_seq extends cpu_base_sequence;

function new(string name="read_word_seq");
    super.new(name);
endfunction
  
`uvm_object_utils(read_word_seq)

rand logic [7:0] raddr;

virtual task body();
    `uvm_do_with(req, {req.addr == raddr; req.rw == cpu_transaction::READ; req.dout == 32'h0;} )
endtask

endclass

class write_word_seq extends cpu_base_sequence;

function new(string name="write_word_seq");
    super.new(name);
endfunction
  
`uvm_object_utils(write_word_seq)

rand logic [7:0] waddr;
rand logic [31:0] wdout;

virtual task body();
    `uvm_do_with(req, {req.addr == waddr; req.rw == cpu_transaction::WRITE; req.dout == wdout;} )
endtask

endclass

`endif

