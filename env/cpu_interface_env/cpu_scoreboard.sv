`ifndef __CPU_SCOREBOARD_SV__
`define __CPU_SCOREBOARD_SV__

`include "cpu_transaction.sv"

class cpu_scoreboard extends uvm_scoreboard;

uvm_analysis_imp#(cpu_transaction, cpu_scoreboard) item_collected_export;

protected bit disable_scoreboard = 0;
int sbd_error = 0;
logic [31:0] cpu_reg [7:0];
integer error_no = 0;
integer total_no = 0;

`uvm_component_utils_begin(cpu_scoreboard)
    `uvm_field_int(disable_scoreboard, UVM_DEFAULT)
`uvm_component_utils_end

function new(string name, uvm_component parent);
    super.new(name, parent);

    for(int i=0; i<128; i++) begin
        cpu_reg[i] = 32'h0;
    end
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
endfunction
  
virtual function void write(cpu_transaction tr);
    if(!disable_scoreboard) begin
        compare(tr);
    end
endfunction : write

protected function void compare(cpu_transaction data);
    cpu_transaction tr;
    string message;

    $cast(tr, data);

    if(tr.rw == cpu_transaction::WRITE) begin
        cpu_reg[tr.addr] = tr.din;
    end
    else if(tr.rw == cpu_transaction::READ) begin
        if(cpu_reg[tr.addr] != tr.din) begin
            message = $psprintf("[Error] %t Comparision result is not correct\n", $realtime);
            message = { message, $psprintf("cpu_reg[%d] = %0h, tr.din = %0h\n", tr.addr, cpu_reg[tr.addr], tr.din) };
            $display(message);
            error_no++;
        end
        else begin
            $display("[Note] %t comparison correct", $realtime);
        end
    end
    else begin
        $display("[Error] tr.rw can only be READ or WRITE");
        error_no++;
    end
endfunction

virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    $dipslay(phase.get_state());

    if(!disable_scoreboard) begin
        `uvm_info(get_type_name(), $sformatf("Reporting scoreboard information...\n%s", this.sprint()), UVM_LOW)
    end
endfunction

endclass

//class cpu_driver_sb_callback extends cpu_driver_callback;
//    cpu_scoreboard cpu_sb;
//
//    function new(cpu_scoreboard cpu_sb);
//        this.cpu_sb = cpu_sb;
//    endfunction
//
//    virtual task driver_post_transactor(cpu_driver xactor, ref cpu_transaction cpu_tr);
//        cpu_sb.compare(cpu_tr);
//    endtask
//endclass

`endif

