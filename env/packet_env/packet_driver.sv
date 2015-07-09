`ifndef __PACKET_DRIVER_SV__
`define __PACKET_DRIVER_SV__

`include "packet_interface.svi"
`include "packet_transaction.sv"

class packet_driver extends uvm_driver #(packet_transaction);

virtual packet_interface pkt_vif;
uvm_analysis_port #(packet_transaction) drv2sb_port;

`uvm_component_utils(packet_driver)

extern function new(string name, uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task main_phase(uvm_phase phase);

task reset_phase(uvm_phase phase);
    super.reset_phase(phase);

    phase.raise_objection(this);

    pkt_vif.cb.tx_vld <= 1'b0;
    pkt_vif.cb.txd    <= 8'h0;
    @(posedge pkt_vif.rst_n);
    repeat(10) @(pkt_vif.cb);

    phase.drop_objection(this);
endtask;


virtual protected task get_and_drive();

    forever begin
        int delay;
        packet_transaction pkt_tr;
        packet_transaction cb_pkt_tr;

        seq_item_port.get_next_item(pkt_tr);
        //pkt_tr.display();

        //cb_pkt_tr = pkt_tr.copy();
        //`callback_macro(packet_driver_callback, driver_pre_transactor(this, cb_pkt_tr, drop))
        drv2sb_port.write(pkt_tr);

        @(pkt_vif.cb);
        pkt_vif.cb.tx_vld <= 1'b1;
        pkt_vif.cb.txd    <= pkt_tr.header[15:8];
        @(pkt_vif.cb);
        pkt_vif.cb.txd    <= pkt_tr.header[7:0];

        foreach(pkt_tr.payload[i]) begin
            @(pkt_vif.cb);
            pkt_vif.cb.txd    <= pkt_tr.payload[i];
        end

        if(pkt_tr.frame_interval > pkt_tr.payload.size())
            delay = pkt_tr.frame_interval;
        else
            delay = pkt_tr.payload.size();
        repeat(delay) begin
            @(pkt_vif.cb);
            pkt_vif.cb.tx_vld <= 1'b0;
        end

        seq_item_port.item_done();

    end
endtask

endclass

//class packet_driver_callback extends transactor_callback;
//    virtual task driver_pre_transactor (packet_driver xactor, ref packet_transaction pkt_tr, ref bit drop);
//    endtask
//    virtual task driver_post_transactor (packet_driver xactor, ref packet_transaction pkt_tr);
//    endtask
//endclass

function packet_driver::new(string name, uvm_component parent);
    super.new(name, parent);

    drv2sb_port = new("drv2sb_port", this);
endfunction

function void packet_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual packet_interface)::get(this, "", "pkt_vif", pkt_vif)) begin
        `uvm_fatal("NOVIF", {"virutal interface must be set for: ", get_full_name(), ".pkt_vif"});
    end
endfunction

task packet_driver::main_phase(uvm_phase phase);
    super.main_phase(phase);

    `uvm_info(get_full_name(),$sformatf(" Packet Driver"), UVM_MEDIUM)

    fork
        get_and_drive();
    join
endtask

`endif

