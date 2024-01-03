module Cache_hit_validation(
    input [9:0] tag_way0, tag_way1, tag_address,
    input valid_way0, valid_way1,
    input [63:0] data_way0, data_way1,
    input [2:0] offset,
    output hit,
    output [31:0] data_out
);
    wire comperator_out0, comperator_out1, sel1, sel2;
    wire [63:0] selected_data;

    assign comperator_out0 = (tag_way0 == tag_address) ? 1'b1 : 1'b0;
    assign comperator_out1 = (tag_way1 == tag_address) ? 1'b1 : 1'b0;

    assign sel0 = valid_way0 & comperator_out0;
    assign sel1 = valid_way1 & comperator_out1;

    assign hit = sel0 | sel1;

    Cache_MUX2 mux(.inp0(data_way0), .inp1(data_way1), .sel0(sel0), .sel1(sel1), .out_put(selected_data));

    assign data_out = offset[2] ? selected_data[63:32] : selected_data[31:0];

endmodule