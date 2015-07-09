`ifndef _PACKET_BASE_SEQUENCE_SV__
`define _PACKET_BASE_SEQUENCE_SV__

virtual class packet_base_sequence extends uvm_sequence #(packet_transaction);

function new(string name="packet_base_sequence");
    super.new(name);
    set_automatic_phase_objection(1);
endfunction
  
endclass

class send_one_pkt_seq extends packet_base_sequence;

function new(string name="send_one_pkt_seq");
    super.new(name);
endfunction
  
`uvm_object_utils(send_one_pkt_seq)

rand packet_transaction::head_type     pkt_head_type     ;
rand packet_transaction::packet_length pkt_packet_length ;
rand logic [6:0 ]                      frame_interval    ;

virtual task body();
    `uvm_do_with(req, {req.pkt_head_type == pkt_head_type; req.pkt_packet_length == pkt_packet_length; req.frame_interval == frame_interval;} )
endtask
  
endclass

`endif

