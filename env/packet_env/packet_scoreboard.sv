`ifndef __PACKET_SCOREBOARD_SV__
`define __PACKET_SCOREBOARD_SV__

`include "packet_transaction.sv"
`include "packet_rm.sv"

`uvm_analysis_imp_decl(_rcvd_pkt)
`uvm_analysis_imp_decl(_sent_pkt)

class packet_scoreboard extends uvm_scoreboard;

uvm_analysis_imp_rcvd_pkt #(packet_transaction, packet_scoreboard) mon2sb_port;
uvm_analysis_imp_sent_pkt #(packet_transaction, packet_scoreboard) drv2sb_port;

packet_rm pkt_rm;
packet_transaction ref_pkt_tran[$];

integer error_no = 0;
integer send_no = 0;
integer receive_no = 0;

protected bit disable_scoreboard = 0;
int sbd_error = 0;

`uvm_component_utils_begin(packet_scoreboard)
    `uvm_field_int(disable_scoreboard, UVM_DEFAULT)
`uvm_component_utils_end

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    mon2sb_port = new("mon2sb", this);
    drv2sb_port = new("drv2sb", this);

    pkt_rm = packet_rm::type_id::create("pkt_rm", this);
endfunction

virtual function void report_phase(uvm_phase phase);
    if(!disable_scoreboard) begin
        `uvm_info(get_type_name(), $sformatf("Reporting scoreboard information...\n%s", this.sprint()), UVM_LOW)
    end
endfunction

virtual function void write_rcvd_pkt(input packet_transaction pkt_tr);
    receive_no++;

    if(ref_pkt_tran.size() > 0) begin
        packet_transaction ref_pkt_tr = ref_pkt_tran.pop_front();

        if(pkt_tr.compare(ref_pkt_tr)) begin
            uvm_report_info(get_type_name(), $psprintf("Sent packet and received packet matched"), UVM_LOW);
        end
        else begin
            error_no++;
            uvm_report_error(get_type_name(), $psprintf("Sent packet and received packet mismatched"), UVM_LOW);

            sbd_error = 1;
        end

        display("[PKT][RECV]");
    end
    else begin
        error_no++;
        display("[PKT][RECV][RECV PKT > SEND PKT]");

        sbd_error = 1;

        uvm_report_error(get_type_name(), $psprintf("No more packets to in the expected queue to compare"), UVM_LOW);
    end

endfunction
 
virtual function void write_sent_pkt(input packet_transaction pkt_tr);
    bit drop;
    packet_transaction cb_pkt_tr;

    if(!pkt_rm.packet_process(pkt_tr)) begin
        drop = 1;
    end
    else begin
        $cast(cb_pkt_tr, pkt_tr.clone());
        ref_pkt_tran.push_back(pkt_tr);
        send_no++;
        drop = 0;

        display("[PKT][SEND]");
    end

endfunction

function display(string prefix);
    `uvm_info(get_type_name(), $sformatf("%s Send: %d, Receive: %d, Error: %d", prefix, send_no, receive_no, error_no), UVM_NONE);
endfunction

endclass

`endif

