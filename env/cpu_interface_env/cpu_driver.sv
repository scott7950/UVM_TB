`ifndef __CPU_DRIVER_SV__
`define __CPU_DRIVER_SV__

`include "cpu_interface.svi"
`include "cpu_transaction.sv"

class cpu_driver extends uvm_driver #(cpu_transaction);

protected virtual cpu_interface cpu_vif;

`uvm_component_utils(cpu_driver)

extern function new(string name, uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task main_phase(uvm_phase phase);

task reset_phase(uvm_phase phase);
    super.reset_phase(phase);

    phase.raise_objection(this);

    cpu_vif.cb.addr   <= 'h0;
    cpu_vif.cb.dout   <= 'h0;
    cpu_vif.cb.rw     <= 1'b0;
    cpu_vif.cb.enable <= 1'b0;
    @(posedge cpu_vif.rst_n);
    repeat(10) @(cpu_vif.cb);

    phase.drop_objection(this);
endtask;
  
virtual protected task get_and_drive();
    forever begin
        cpu_transaction cpu_tr;
        seq_item_port.get_next_item(cpu_tr);
        //cpu_tr.print();

        @(cpu_vif.cb);
        cpu_vif.cb.addr   <= cpu_tr.addr;
        cpu_vif.cb.dout   <= cpu_tr.dout;
        if(cpu_tr.rw == cpu_transaction::WRITE) begin
            cpu_vif.cb.rw <= 1'b0;
        end
        else begin
            cpu_vif.cb.rw <= 1'b1;
        end
        cpu_vif.cb.enable <= 1'b1;

        @(cpu_vif.cb);
        cpu_vif.cb.enable <= 1'b0;

        //`uvm_do_callbacks(cpu_driver, cpu_driver_cbs, driver_post_transactor(this, cpu_tr))
        seq_item_port.item_done();
    end
endtask

endclass

//class cpu_driver_cbs extends uvm_callback;
//virtual task driver_pre_transactor(cpu_driver xactor, cpu_transaction cpu_tr); endtask
//virtual task driver_post_transactor(cpu_driver xactor, cpu_transaction cpu_tr); endtask
//endclass

function cpu_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void cpu_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual cpu_interface)::get(this, "", "cpu_vif", cpu_vif)) begin
        `uvm_fatal("NOVIF", {"virutal interface must be set for: ", get_full_name(), ".cpu_vif"});
    end

endfunction

task cpu_driver::main_phase(uvm_phase phase);
    super.main_phase(phase);

    `uvm_info(get_full_name(),$sformatf(" CPU Driver"), UVM_MEDIUM)

    fork
      get_and_drive();
    join
endtask

`endif

