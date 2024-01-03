module Cache(
    input clk, rst, W_EN, R_EN,
    input[31:0] address, data_in,
    output[31:0] data_out,

    output reg ready
);
    wire [17:0] upper_addr, lower_addr;

    reg [63:0] way0_data [0:63];
    reg [63:0] way1_data [0:63];
    reg [63:0] valid_bit_way0;
    reg [63:0] valid_bit_way1;
    reg [9:0] tag_bit_way0 [0:63];
    reg [9:0] tag_bit_way1 [0:63];
    reg [63:0] LRU;

    assign upper_addr = {address[18:2] , 1'b0};
    assign lower_addr = {address[18:2] , 1'b1};

endmodule