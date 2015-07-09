`ifndef __CPU_WRITE_AND_READ_SV__
`define __CPU_WRITE_AND_READ_SV__

`include "cpu_base_sequence.sv"

class cpu_write_and_read extends cpu_base_sequence;

read_word_seq r_seq;
write_word_seq w_seq;

logic [9:0] min_pkt_size;
logic [9:0] max_pkt_size;

`uvm_declare_p_sequencer(system_virtual_sequencer)

`uvm_object_utils(cpu_write_and_read)

function new(string name="cpu_write_and_read");
    super.new(name);

    uvm_config_db#(int)::get(uvm_root::get(), "", "min_pkt_size", min_pkt_size);
    uvm_config_db#(int)::get(uvm_root::get(), "", "max_pkt_size", max_pkt_size);

    if(min_pkt_size == 0) begin
        min_pkt_size = 32'd64;
    end

    if(max_pkt_size == 0) begin
        max_pkt_size = 32'd512;
    end

endfunction : new

virtual task body();
    `uvm_do_on_with(w_seq, p_sequencer.cpu_sqr, {w_seq.waddr == 8'h4; w_seq.wdout == 'd65;})
    `uvm_do_on_with(r_seq, p_sequencer.cpu_sqr, {r_seq.raddr == 8'h4;})
    `uvm_do_on_with(w_seq, p_sequencer.cpu_sqr, {w_seq.waddr == 8'h8; w_seq.wdout == 'd500;})
    `uvm_do_on_with(r_seq, p_sequencer.cpu_sqr, {r_seq.raddr == 8'h8;})
    `uvm_do_on_with(w_seq, p_sequencer.cpu_sqr, {w_seq.waddr == 8'h0; w_seq.wdout == 'h1;})
    `uvm_do_on_with(r_seq, p_sequencer.cpu_sqr, {r_seq.raddr == 8'h0;})
endtask : body

endclass

class cpu_write_and_read1 extends cpu_base_sequence;

read_word_seq r_seq;
write_word_seq w_seq;

logic [9:0] min_pkt_size;
logic [9:0] max_pkt_size;

`uvm_object_utils(cpu_write_and_read1)

function new(string name="cpu_write_and_read1");
    super.new(name);

    uvm_config_db#(int)::get(uvm_root::get(), "", "min_pkt_size", min_pkt_size);
    uvm_config_db#(int)::get(uvm_root::get(), "", "max_pkt_size", max_pkt_size);

    if(min_pkt_size == 0) begin
        min_pkt_size = 32'd64;
    end

    if(max_pkt_size == 0) begin
        max_pkt_size = 32'd512;
    end

endfunction : new

virtual task body();
    `uvm_do_with(w_seq, {w_seq.waddr == 8'h4; w_seq.wdout == 'd65;})
    `uvm_do_with(r_seq, {r_seq.raddr == 8'h4;})
    `uvm_do_with(w_seq, {w_seq.waddr == 8'h8; w_seq.wdout == 'd500;})
    `uvm_do_with(r_seq, {r_seq.raddr == 8'h8;})
    `uvm_do_with(w_seq, {w_seq.waddr == 8'h0; w_seq.wdout == 'h1;})
    `uvm_do_with(r_seq, {r_seq.raddr == 8'h0;})
endtask : body

endclass


`endif

