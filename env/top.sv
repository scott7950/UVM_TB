`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "cpu_interface.svi"
`include "packet_interface.svi"
`include "test.sv"

module top;
parameter clock_cycle = 10;

logic clk;
logic rst_n;

cpu_interface cpu_intf(clk, rst_n);
packet_interface pkt_intf(clk, rst_n);

dut u_dut (
    .clk    (clk             ) ,
    .rst_n  (rst_n           ) ,

    .addr   (cpu_intf.addr   ) ,
    .rw     (cpu_intf.rw     ) ,
    .enable (cpu_intf.enable ) ,
    .din    (cpu_intf.dout   ) ,
    .dout   (cpu_intf.din    ) ,

    .txd    (pkt_intf.rxd    ) ,
    .tx_vld (pkt_intf.rx_vld ) ,
    .rxd    (pkt_intf.txd    ) ,
    .rx_vld (pkt_intf.tx_vld )   
);

initial begin
    $timeformat(-9, 1, "ns", 10);
    clk = 0;
    forever begin
        #(clock_cycle/2) clk = ~clk;
    end
end

initial begin
    rst_n = 1'b1;
    repeat(10) @(posedge clk);
    rst_n = 1'b0;
    repeat(10) @(posedge clk);
    rst_n = 1'b1;
end

initial begin
    uvm_config_db#(virtual cpu_interface)::set(uvm_root::get(), "*", "cpu_vif", cpu_intf);
    uvm_config_db#(virtual packet_interface)::set(uvm_root::get(), "*", "pkt_vif", pkt_intf);
    run_test();
end

`ifdef WAVE_ON
initial begin
    //$dumpfile("wave.vcd");
    //$dumpvars(0, top);
end
`endif

endmodule

