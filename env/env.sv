`ifndef __ENV_SV__
`define __ENV_SV__

`include "cpu_env.sv"
`include "packet_env.sv"
`include "system_virtual_sequencer.sv"

class env extends uvm_env;

cpu_env u_cpu_env;
packet_env u_pkt_env;
system_virtual_sequencer sys_vir_sqr;

`uvm_component_utils(env)

function new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    u_cpu_env = cpu_env::type_id::create("u_cpu_env", this);
    u_pkt_env = packet_env::type_id::create("u_packet_env", this);
    sys_vir_sqr = system_virtual_sequencer::type_id::create("sys_vir_sqr", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    sys_vir_sqr.cpu_sqr = u_cpu_env.cpu_agt.cpu_sqr;
    sys_vir_sqr.pkt_sqr = u_pkt_env.pkt_agt.pkt_sqr;
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask

endclass

`endif

