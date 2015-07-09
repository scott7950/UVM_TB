`ifndef __CPU_ENV_SV__
`define __CPU_ENV_SV__

`include "cpu_agent.sv"
`include "cpu_scoreboard.sv"

class cpu_env extends uvm_env;

cpu_agent      cpu_agt;
cpu_scoreboard cpu_sb;


protected virtual interface cpu_interface cpu_vif;

//`uvm_component_utils_begin(cpu_env)
//    //`uvm_field_object(cpu_sb, UVM_ALL_ON)
//`uvm_component_utils_end
`uvm_component_utils(cpu_env)

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cpu_agt = cpu_agent::type_id::create("cpu_agt", this);
    cpu_sb = cpu_scoreboard::type_id::create("cpu_sb", this);

endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cpu_agt.cpu_mon.item_collected_port.connect(cpu_sb.item_collected_export);
endfunction : connect_phase

task run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask

endclass

`endif

