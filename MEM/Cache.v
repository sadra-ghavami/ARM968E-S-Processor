module Cache(
    input clk, rst,
    input W_EN, R_EN,
    input[31:0] address, data_in,
    output[31:0] data_out,
    output reg ready,

    output reg SRAM_W_EN, SRAM_R_EN,
    output[31:0] SRAM_address, SRAM_data_in,
    input[63:0] SRAM_data_out,
    input SRAM_ready
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
    wire hit, hit_way0, hit_way1, start;
    wire [31:0] selected_data;

    Cache_hit_validator validator(
        .tag_way0(selected_tag_way0), .tag_way1(selected_tag_way1), .tag_address(tag),
        .valid_way0(selected_valid_way0), .valid_way1(selected_data_way1),
        .data_way0(selected_data_way0), .data_way1(selected_data_way1),
        .offset(offset),
        .hit(hit), .hit_way0(hit_way0), .hit_way1(hit_way1),
        .data_out(selected_data)
    );

    // Meely State Machine
    localparam[2:0] IDLE = 3'b000, READ_STATE = 3'b001, PUT_DATA_STATE = 3'b010,
                    WRITE_STATE = 3'b011, WRITEBACK_DATA_STATE = 3'b100, READY_STATE = 3'b101;
    reg[2:0] ps, ns;

    integer i;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            for(i=0; i<64; i=i+1) begin
                LRU[i] = 1'b0;
                valid_bit_way0[i] = 1'b0;
                valid_bit_way1[i] = 1'b0;
                tag_bit_way0[i] = 0;
                tag_bit_way1[i] = 0;
                way0_data[i] = 64'b0;
                way1_data[i] = 64'b0;
            end
            ps <= IDLE;
        end
        else
            ps <= ns;
    end

    always @(ps, start, W_EN, R_EN, SRAM_ready) begin
        ns <= IDLE;
        case(ps)
            IDLE: ns <= start ? W_EN ? WRITE_STATE : READ_STATE : IDLE;
            READ_STATE: ns <= SRAM_ready ? PUT_DATA_STATE : READ_STATE;
            PUT_DATA_STATE: ns <= READY_STATE;
            WRITE_STATE: ns <= SRAM_ready ? WRITEBACK_DATA_STATE : WRITE_STATE;
            WRITEBACK_DATA_STATE: ns <= READY_STATE;
            READY_STATE: ns <= IDLE;
            default: ns <= IDLE;
        endcase
    end

    always @(ps, start, index, hit_way0, hit_way1, SRAM_data_out) begin
        {ready, SRAM_W_EN, SRAM_R_EN} = 3'b000;
        case(ps)
            IDLE: ready = ~start;
            READ_STATE: SRAM_R_EN = 1'b1;
            PUT_DATA_STATE: begin
                if(LRU[index]) begin
                    way1_data[index] = SRAM_data_out;
                    tag_bit_way1[index] = tag;
                    valid_bit_way1[index] = 1'b1;
                end
                else begin
                    way0_data[index] = SRAM_data_out;
                    tag_bit_way0[index] = tag;
                    valid_bit_way0[index] = 1'b1;
                end
                LRU[index] = ~LRU[index];
            end
            WRITE_STATE: SRAM_W_EN = 1'b1;
            WRITEBACK_DATA_STATE: begin
                if(hit_way0) begin
                    valid_bit_way0[index] = 1'b0;
                    LRU[index] = 1'b0;
                end
                else if(hit_way1) begin
                    valid_bit_way1[index] = 1'b0;
                    LRU[index] = 1'b1;
                end
                else;
            end
            READY_STATE: ready = 1'b1;
            default: {ready, SRAM_W_EN, SRAM_R_EN} = 3'b000;
        endcase
    end

    assign SRAM_address = address;
    assign SRAM_data_in = data_in;
    
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
    assign data_out = selected_data;
    

endmodule