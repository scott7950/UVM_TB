`ifndef __SYSTEM_SEQUENCE_SV__
`define __SYSTEM_SEQUENCE_SV__

`include "cpu_transaction.sv"
`include "cpu_sequence.sv"
`include "packet_sequence.sv"

//class cpu_rw_and_send_pkts extends uvm_sequence #(uvm_sequence_item);
class cpu_rw_and_send_pkts extends cpu_base_sequence;

cpu_write_and_read  cpu_rw;
packet_send_packets send_pkts;

`uvm_object_utils(cpu_rw_and_send_pkts)

function new(string name="cpu_write_and_read");
    super.new(name);

    cpu_rw    = new("cpu configuration");
    send_pkts = new("send packets");
endfunction

virtual task body();
    `uvm_do(cpu_rw)
    `uvm_do(send_pkts)
endtask

endclass

class cpu_rw_and_send_pkts1 extends cpu_base_sequence;

cpu_write_and_read1  cpu_rw;
packet_send_packets1 send_pkts;

`uvm_declare_p_sequencer(system_virtual_sequencer)

`uvm_object_utils(cpu_rw_and_send_pkts1)

function new(string name="cpu_rw_and_send_pkts1");
    super.new(name);

    cpu_rw    = new("cpu configuration");
    send_pkts = new("send packets");
endfunction

virtual task body();
    `uvm_do_on(cpu_rw, p_sequencer.cpu_sqr)
    `uvm_do_on(send_pkts, p_sequencer.pkt_sqr)
endtask

endclass

`endif

