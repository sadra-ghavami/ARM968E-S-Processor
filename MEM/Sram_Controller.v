module Sram_Controller(clk, rst, W_EN, R_EN, address, data_in, data_out, ready,SRAM_DQ,
                    SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N);
    input clk, rst, W_EN, R_EN;
    input[31:0] address, data_in;
    output[63:0] data_out;

    output reg ready;

    inout [15:0] SRAM_DQ;
    output reg [17:0] SRAM_ADDR;
    output  SRAM_UB_N;
    output  SRAM_LB_N;
    output  reg SRAM_WE_N;
    output  SRAM_CE_N;
    output  SRAM_OE_N;

    reg [15:0] write_data;
    wire tri_state_control;
    wire [17:0] write_upper_addr, write_lower_addr, read_first_addr, read_second_addr, read_third_addr, read_forth_addr;

    reg [15:0] first_data, second_data, third_data, forth_data;

    assign write_upper_addr = {address[18:2] , 1'b0};
    assign write_lower_addr = {address[18:2] , 1'b1};

    assign read_first_addr = {address[18:3] , 2'b00};
    assign read_second_addr = {address[18:3] , 2'b01};
    assign read_third_addr = {address[18:3] , 2'b10};
    assign read_forth_addr = {address[18:3] , 2'b11};

    reg [3:0] ps,ns ;
    parameter [3:0] IDLE = 4'b0, WRITE_LOW = 4'b0001, WRITE_HIGH = 4'b0010, WRITE_END = 4'b0011,
                    FIRST_READ = 4'b0100, SECOND_READ = 4'b0101, THIRD_READ = 4'b0110, FORTH_READ = 4'b0111,
                    GET_LAST_DATA = 4'b1000, STALL = 4'b1001, READY_STATE = 4'b1010;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            ps <= 4'b0;
        end
        else begin
            ps <= ns;
        end
    end

    always @(ps, W_EN, R_EN) begin
        ns <= IDLE;
        case (ps)
            IDLE: ns <= (~W_EN && ~R_EN) ? IDLE : W_EN ? WRITE_LOW : READ_LOW;
            WRITE_LOW: ns <= WRITE_HIGH;
            WRITE_HIGH: ns <= WRITE_END;
            WRITE_END: ns <= STALL;
            STALL: ns <= READY_STATE;
            READY_STATE: ns <= IDLE;
            FIRST_READ: ns <= SECOND_READ;
            SECOND_READ: ns <= THIRD_READ;
            THIRD_READ: ns <= FORTH_READ;
            FORTH_READ: ns <= GET_LAST_DATA;
            GET_LAST_DATA: ns <= IDLE;
            default: ns <= IDLE;
        endcase
        
    end

    always @(ps) begin
        SRAM_WE_N = 1'b1; write_data = 16'b0; SRAM_ADDR = 18'b0; ready = 1'b0;
        case (ps)
            WRITE_LOW: begin
                SRAM_ADDR = write_lower_addr;
                SRAM_WE_N = 1'b0;
                write_data = data_in [15:0];
            end
            WRITE_HIGH: begin
                SRAM_ADDR = write_upper_addr;
                SRAM_WE_N = 1'b0;
                write_data = data_in [31:16];
            end

            READY_STATE: ready = 1'b1;

            FIRST_READ: begin
                SRAM_ADDR = read_first_addr;
            end
            SECOND_READ: begin
                SRAM_ADDR = read_second_addr;
                first_data = SRAM_DQ;
            end
            THIRD_READ: begin
                SRAM_ADDR = read_third_addr;
                second_data = SRAM_DQ;
            end
            FORTH_READ: begin
                SRAM_ADDR = read_forth_addr;
                third_data = SRAM_DQ;
            end
            GET_LAST_DATA: begin
                forth_data = SRAM_DQ;
                ready = 1'b1;
            end
            default: begin
                SRAM_WE_N = 1'b1; write_data = 16'b0; SRAM_ADDR = 18'b0; ready = 1'b0;
            end
        endcase
    end

    assign tri_state_control = SRAM_WE_N;
    assign SRAM_DQ = ~tri_state_control ? write_data : 16'bz;

    assign SRAM_UB_N = 1'b0;
    assign SRAM_LB_N = 1'b0;
    assign SRAM_CE_N = 1'b0;
    assign SRAM_OE_N = 1'b0;
    assign data_out = {forth_data, third_data, second_data, first_data};

endmodule

// module Sram_Controller(clk, rst, W_EN, R_EN, address, data_in, data_out, ready,SRAM_DQ,
                    // SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N);
    // input clk, rst, W_EN, R_EN;
    // input[31:0] address, data_in;
    // output[31:0] data_out;
// 
    // output reg ready;
// 
    // inout [15:0] SRAM_DQ;
    // output reg [17:0] SRAM_ADDR;
    // output  SRAM_UB_N;
    // output  SRAM_LB_N;
    // output  reg SRAM_WE_N;
    // output  SRAM_CE_N;
    // output  SRAM_OE_N;
// 
    // reg [15:0] write_data;
    // wire tri_state_control;
    // wire [17:0] upper_addr, lower_addr;
// 
    // reg [15:0] lower_data, upper_data;
// 
    // assign upper_addr = {address[18:2] , 1'b0};
    // assign lower_addr = {address[18:2] , 1'b1};
// 
    // reg [3:0] ps,ns ;
    // parameter [3:0] IDLE = 4'b0, WRITE_LOW = 4'b0001, WRITE_HIGH = 4'b0010, WRITE_END = 4'b0011,
                    // ADDR_LOW = 4'b0100, READ_LOW = 4'b0101, ADDR_HIGH = 4'b0110, STALL = 4'b0111,
                    // READY_STATE = 4'b1000, READ_HIGH = 4'b1001;
// 
    // always @(posedge clk, posedge rst) begin
        // if (rst) begin
            // ps <= 4'b0;
        // end
        // else begin
            // ps <= ns;
        // end
    // end
// 
    // always @(ps, W_EN, R_EN) begin
        // ns <= IDLE;
        // case (ps)
            // IDLE: ns <= (~W_EN && ~R_EN) ? IDLE : W_EN ? WRITE_LOW : ADDR_LOW;
            // WRITE_LOW: ns <= WRITE_HIGH;
            // WRITE_HIGH: ns <= WRITE_END;
            // WRITE_END: ns <= STALL;
            // STALL: ns <= READY_STATE;
            // READY_STATE: ns <= IDLE;
            // ADDR_LOW: ns <= READ_LOW;
            // READ_LOW: ns <= ADDR_HIGH;
            // ADDR_HIGH: ns <= READ_HIGH;
            // READ_HIGH: ns <= READY_STATE;
            // default: ns <= IDLE;
        // endcase
        // 
    // end
// 
    // always @(ps) begin
        // SRAM_WE_N = 1'b1; write_data = 16'b0; SRAM_ADDR = 18'b0; ready = 1'b0;
        // case (ps)
            // WRITE_LOW: begin
                // SRAM_ADDR = lower_addr;
                // SRAM_WE_N = 1'b0;
                // write_data = data_in [15:0];
            // end
            // WRITE_HIGH: begin
                // SRAM_ADDR = upper_addr;
                // SRAM_WE_N = 1'b0;
                // write_data = data_in [31:16];
            // end
            // READY_STATE: ready = 1'b1;
            // ADDR_LOW: begin
                // SRAM_ADDR = lower_addr;
            // end
            // READ_LOW: begin
                // SRAM_ADDR = lower_addr;
                // lower_data = SRAM_DQ;
            // end
            // ADDR_LOW: begin
                // SRAM_ADDR = upper_addr;
            // end
            // READ_HIGH: begin
                // SRAM_ADDR = upper_addr;
                // upper_data = SRAM_DQ;
            // end
            // default: begin
                // SRAM_WE_N = 1'b1; write_data = 16'b0; SRAM_ADDR = 18'b0; ready = 1'b0;
            // end
        // endcase
    // end
// 
    // assign tri_state_control = SRAM_WE_N;
    // assign SRAM_DQ = ~tri_state_control ? write_data : 16'bz;
// 
    // assign SRAM_UB_N = 1'b0;
    // assign SRAM_LB_N = 1'b0;
    // assign SRAM_CE_N = 1'b0;
    // assign SRAM_OE_N = 1'b0;
    // assign data_out = {upper_data, lower_data};
// 
// endmodule