`ifndef __PACKET_TRANSACTION_SV__
`define __PACKET_TRANSACTION_SV__

class packet_transaction extends uvm_sequence_item;

typedef enum {GOOD, BAD} head_type;
typedef enum {LONG, SHORT, NORMAL} packet_length;
rand head_type     pkt_head_type     ;
rand packet_length pkt_packet_length ;
rand logic [15:0] header     ;
rand logic [7:0 ] payload[$] ;
rand logic [6:0 ] frame_interval;

extern function new(string name = "Packet Transaction");

function void byte2pkt(ref logic[7:0] data[$]);
    if(data.size() >= 2) begin
        header[15:8] = data.pop_front();
        header[7:0]  = data.pop_front();
    end

    foreach(data[i]) begin
        payload.push_back(data[i]);
    end

endfunction

`uvm_object_utils_begin(packet_transaction)
    `uvm_field_enum(head_type, pkt_head_type, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_field_enum(packet_length, pkt_packet_length, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_field_int(header, UVM_ALL_ON)
    `uvm_field_queue_int(payload, UVM_ALL_ON)
    `uvm_field_int(frame_interval, UVM_ALL_ON | UVM_NOCOMPARE)
`uvm_object_utils_end

constraint con_head_type {
    solve pkt_head_type before header;
    pkt_head_type dist {GOOD := 5, BAD := 1};
    (pkt_head_type == GOOD) -> (header == 16'h55d5);
    (pkt_head_type == BAD) -> (header inside {[0:16'h55d4], [16'h55d6:16'hffff]});
}

constraint con_pkt_len {
    solve pkt_packet_length before payload;
    pkt_packet_length dist {LONG := 1, SHORT := 1, NORMAL := 5};
    (pkt_packet_length == LONG) -> (payload.size() inside {[0:49]});
    (pkt_packet_length == SHORT) -> (payload.size() inside {[50:500]});
    (pkt_packet_length == NORMAL) -> (payload.size() inside {[501:600]});
}

constraint con_frame_interval {
    frame_interval inside {[96:200]};
}

virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
      packet_transaction rhs_;
      do_compare = super.do_compare(rhs,comparer);

      $cast(rhs_,rhs);
      do_compare &= comparer.compare_field_int("Header", header, rhs_.header, 16);
      do_compare &= comparer.compare_field_int("Payload Size", payload.size(), rhs_.payload.size(), 64);
      if(do_compare) begin
          foreach (rhs_.payload[i]) begin
              do_compare &= comparer.compare_field_int("Payload", payload[i], rhs_.payload[i], 8);
          end
      end

endfunction

function uvm_object clone();
    packet_transaction tr = new(); 

    tr.copy(this);
    return tr;
endfunction

function void do_copy (uvm_object rhs);
    packet_transaction rhs_;
    super.do_copy(rhs);

    $cast(rhs_, rhs);

    header = rhs_.header;
    foreach(rhs_.payload[i]) begin
        payload.push_back(rhs_.payload[i]);
    end

endfunction

endclass

function packet_transaction::new(string name = "Packet Transaction");
    super.new(name);
endfunction

`endif

