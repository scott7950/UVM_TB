`ifndef __TEST_SV__
`define __TEST_SV__

`include "env.sv"
`include "cpu_sequence.sv"
`include "packet_sequence.sv"
`include "system_sequence.sv"

class base_test extends uvm_test;

env tb_env;
bit test_pass = 1;
uvm_table_printer printer;

`uvm_component_utils(base_test)

function new(string name="base_test", uvm_component parent=null);
    super.new(name, parent);

    uvm_config_db#(int)::set(uvm_root::get(), "*", "min_pkt_size", 'd65);
    uvm_config_db#(int)::set(uvm_root::get(), "*", "max_pkt_size", 'd500);

endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    tb_env = env::type_id::create("tb_env", this);
    printer = new();
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW)
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask

function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);

    if(tb_env.u_cpu_env.cpu_sb.sbd_error || tb_env.u_pkt_env.pkt_sb.sbd_error || tb_env.u_pkt_env.pkt_sb.ref_pkt_tran.size() != 0) begin
        test_pass = 0;
    end

endfunction

function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    if(test_pass) begin
        `uvm_info(get_type_name(), "** UVM TEST PASSED **", UVM_NONE)
    end
    else begin
        `uvm_error(get_type_name(), "** UVM TEST FAIL **")
    end
endfunction

endclass

class test extends base_test;

`uvm_component_utils(test)

function new(string name="test", uvm_component parent=null);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    cpu_rw_and_send_pkts cpu_and_pkt;

    super.build_phase(phase);

    cpu_and_pkt = cpu_rw_and_send_pkts::type_id::create();
    uvm_config_db#(uvm_sequence_base)::set(this, "tb_env.sys_vir_sqr.main_phase", "default_sequence", cpu_and_pkt);
endfunction

endclass

class test3 extends base_test;

`uvm_component_utils(test3)

function new(string name="test3", uvm_component parent=null);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    cpu_rw_and_send_pkts1 cpu_and_pkt;

    super.build_phase(phase);

    cpu_and_pkt = cpu_rw_and_send_pkts1::type_id::create();
    uvm_config_db#(uvm_sequence_base)::set(this, "tb_env.sys_vir_sqr.main_phase", "default_sequence", cpu_and_pkt);
endfunction

endclass

`endif

