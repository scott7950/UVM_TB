`ifndef __PACKET_SEND_PACKETS_SV__
`define __PACKET_SEND_PACKETS_SV__

`include "packet_base_sequence.sv"

class packet_send_packets extends packet_base_sequence;

int itr = 100;
send_one_pkt_seq pkt_seq;

`uvm_declare_p_sequencer(system_virtual_sequencer)

`uvm_object_utils(packet_send_packets)

function new(string name="packet_send_packets");
    super.new(name);
endfunction

virtual task body();
    //void'(uvm_config_db#(int)::get(null,get_full_name(),"itr", itr));
    `uvm_info(get_type_name(), $sformatf("%s starting...itr = %0d", get_sequence_path(), itr), UVM_NONE);
    for(int i = 0; i < itr; i++) begin
        `uvm_do_on(pkt_seq, p_sequencer.pkt_sqr)
    end
endtask : body

endclass

class packet_send_packets1 extends packet_base_sequence;

int itr = 100;
send_one_pkt_seq pkt_seq;

`uvm_object_utils(packet_send_packets1)

function new(string name="packet_send_packets1");
    super.new(name);
endfunction

virtual task body();
    //void'(uvm_config_db#(int)::get(null,get_full_name(),"itr", itr));
    `uvm_info(get_type_name(), $sformatf("%s starting...itr = %0d", get_sequence_path(), itr), UVM_NONE);
    for(int i = 0; i < itr; i++) begin
        `uvm_do(pkt_seq)
    end
endtask : body

endclass

`endif

