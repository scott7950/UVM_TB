`ifndef __CPU_TRANSACTION_SV__
`define __CPU_TRANSACTION_SV__

class cpu_transaction extends uvm_sequence_item;

typedef enum {READ, WRITE} rw_type;
rand logic [7:0] addr;
rand rw_type rw;
rand logic [31:0] dout;
logic [31:0] din = 32'h0;

extern function new(string name = "CPU Transaction");

`uvm_object_utils_begin(cpu_transaction)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_enum(rw_type, rw, UVM_ALL_ON)
    `uvm_field_int(dout, UVM_ALL_ON)
`uvm_object_utils_end

endclass

function cpu_transaction::new(string name = "CPU Transaction");
    super.new(name);
endfunction

`endif

