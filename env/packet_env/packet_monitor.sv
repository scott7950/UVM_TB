`ifndef __PACKET_MONITOR_SV__
`define __PACKET_MONITOR_SV__

`include "packet_interface.svi"
`include "packet_transaction.sv"

class packet_monitor extends uvm_monitor;

virtual packet_interface pkt_vif;

bit checks_enable = 1;
bit coverage_enable = 1;

uvm_analysis_port #(packet_transaction) mon2sb_port;

`uvm_component_utils_begin(packet_monitor)
  `uvm_field_int(checks_enable, UVM_DEFAULT)
  `uvm_field_int(coverage_enable, UVM_DEFAULT)
`uvm_component_utils_end

function new (string name, uvm_component parent);
    super.new(name, parent);

    mon2sb_port = new("mon2sb_port", this);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual packet_interface)::get(this, "", "pkt_vif", pkt_vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ", get_full_name(), ".pkt_vif"});
endfunction

virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);

    `uvm_info(get_full_name(),$sformatf(" Packet Monitor"), UVM_MEDIUM)

    fork
        collect_transactions();
    join
endtask

virtual protected task collect_transactions();
    //or wait for the global reset
    @(pkt_vif.cb);
    while(pkt_vif.cb.rx_vld !== 1'b0) begin
        @(pkt_vif.cb);
    end

    forever begin
        logic [7:0] rxd[$];
        packet_transaction pkt_tr = new();

        @(pkt_vif.cb);
        while(pkt_vif.cb.rx_vld == 1'b0) begin
            @(pkt_vif.cb);
        end

        while(pkt_vif.cb.rx_vld == 1'b1) begin
            rxd.push_back(pkt_vif.cb.rxd);
            @(pkt_vif.cb);
        end

        pkt_tr.byte2pkt(rxd);
        //pkt_tr.display("Monitor");

        //`callback_macro(packet_monitor_callback, monitor_post_transactor(this, pkt_tr))
        mon2sb_port.write(pkt_tr);
    end
endtask

virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
endfunction

endclass

//class packet_monitor_callback extends transactor_callback;
//    virtual task monitor_pre_transactor (packet_monitor xactor, ref packet_transaction pkt_tr, ref bit drop);
//    endtask
//    virtual task monitor_post_transactor (packet_monitor xactor, ref packet_transaction pkt_tr);
//    endtask
//endclass

`endif

