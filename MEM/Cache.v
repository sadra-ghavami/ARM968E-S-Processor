module Cache(
    input clk, rst, W_EN, R_EN,
    input[31:0] address, data_in,
    output[31:0] data_out,

    output reg ready
);

    reg [63:0] way0_data [0:63];
    reg [63:0] way1_data [0:63];
    reg [63:0] valid_bit_way0;
    reg [63:0] valid_bit_way1;
    reg [9:0] tag_bit_way0 [0:63];
    reg [9:0] tag_bit_way1 [0:63];
    reg [63:0] LRU;

    wire [9:0] selected_tag_way0, selected_tag_way1, tag;
    wire selected_valid_way0, selected_valid_way1;
    wire [63:0] selected_data_way0, selected_data_way1;
    wire [2:0] offset;
    wire [5:0] index;
    wire hit, start;
    wire [31:0] selected_data;

    Cache_hit_validation validator(
        .tag_way0(selected_tag_way0), .tag_way1(selected_tag_way1), .tag_address(tag),
        .valid_way0(selected_valid_way0), .valid_way1(selected_data_way1),
        .data_way0(selected_data_way0), .data_way1(selected_data_way1),
        .offset(offset),
        .hit(hit),
        .data_out(selected_data)
    );


    assign offset = address[2:0];
    assign index = address[8:3];
    assign tag = address[18:9];
    assign selected_tag_way0 = tag_bit_way0[index];
    assign selected_tag_way1 = tag_bit_way1[index];
    assign selected_valid_way0 = valid_bit_way0[index];
    assign selected_valid_way1 = valid_bit_way1[index];
    assign selected_data_way0 = way0_data[index];
    assign selected_data_way1 = way1_data[index];
    assign start = (R_EN & ~hit) | W_EN;
    

endmodule