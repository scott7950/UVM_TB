`ifndef __PACKET_ENV_SV__
`define __PACKET_ENV_SV__

`include "packet_agent.sv"
`include "packet_scoreboard.sv"

class packet_env extends uvm_env;

packet_agent      pkt_agt;
packet_scoreboard pkt_sb;

virtual packet_interface pkt_vif;

`uvm_component_utils(packet_env)

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    pkt_agt = packet_agent::type_id::create("pkt_agt", this);
    pkt_sb = packet_scoreboard::type_id::create("pkt_sb", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    pkt_agt.pkt_drv.drv2sb_port.connect(pkt_sb.drv2sb_port);
    pkt_agt.pkt_mon.mon2sb_port.connect(pkt_sb.mon2sb_port);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask

endclass

`endif

