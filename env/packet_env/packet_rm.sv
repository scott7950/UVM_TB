`ifndef __PACKET_RM_SV__
`define __PACKET_RM_SV__

class packet_rm extends uvm_component;

logic [9:0] min_pkt_size;
logic [9:0] max_pkt_size;

`uvm_component_utils_begin(packet_rm)
    `uvm_field_int(min_pkt_size, UVM_DEFAULT)
    `uvm_field_int(max_pkt_size, UVM_DEFAULT)
`uvm_component_utils_end

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db#(int)::get(this, "", "min_pkt_size", min_pkt_size);
    uvm_config_db#(int)::get(this, "", "max_pkt_size", max_pkt_size);

    if(min_pkt_size == 0) begin
        min_pkt_size = 32'd64;
    end

    if(max_pkt_size == 0) begin
        max_pkt_size = 32'd512;
    end

endfunction

extern function bit packet_process(ref packet_transaction pkt_tr);

endclass

function bit packet_rm::packet_process(ref packet_transaction pkt_tr);
    if(pkt_tr == null) begin
        return 0;
    end

    if(pkt_tr.header != 16'h55d5) begin
        return 0;
    end

    if(pkt_tr.payload.size() < min_pkt_size - 2 || pkt_tr.payload.size() > max_pkt_size - 2) begin
        return 0;
    end

    return 1;
endfunction

`endif

