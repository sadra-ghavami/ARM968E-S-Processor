`timescale 1ns/1ns
module SRAM_test();
    reg clk = 1'b0, rst;
    wire[16:0] SRAM_DQ;
    reg[17:0] SRAM_ADDR;
    reg SRAM_UB_N = 1'b0, SRAM_LB_N = 1'b0, SRAM_WE_N = 1'b1, SRAM_CE_N = 1'b0, SRAM_OE_N = 1'b0;

    SRAM sr(clk, rst, SRAM_DQ, SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N);

    reg[15:0] data;
    assign SRAM_DQ = SRAM_WE_N ? 16'bz : data;

    always #10 clk <= ~clk;

    initial begin
        #2  rst = 1'b1;
        #3  rst = 1'b0;
            SRAM_WE_N = 1'b0;
            SRAM_ADDR = 18'd0;
            data = 16'd1024;
        #20 SRAM_WE_N = 1'b0;
            SRAM_ADDR = 18'd1;
            data = 16'd2048;
        #20 SRAM_WE_N = 1'b1;
            SRAM_ADDR = 18'd0;
        #20 SRAM_WE_N = 1'b1;
            SRAM_ADDR = 18'd1;
        #20 $stop;
    end
endmodule