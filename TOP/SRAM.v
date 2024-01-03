module SRAM(clk, rst, SRAM_DQ, SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N);
    input clk, rst;
    inout [15:0] SRAM_DQ;
    input [17:0] SRAM_ADDR;
    input SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;

    reg[15:0] write_value;
    reg[15:0] mem [0:2047];
    assign SRAM_DQ = SRAM_WE_N ? write_value : 32'bz;
    always@(posedge clk, posedge rst) begin
        if(rst) begin
            write_value = 16'b0;
        end
        else begin
            case(SRAM_WE_N)
                1'b0: mem[SRAM_ADDR] <= SRAM_DQ;
                1'b1: write_value <= mem[SRAM_ADDR];
                default: write_value <= 32'b0;
            endcase
        end
    end


endmodule