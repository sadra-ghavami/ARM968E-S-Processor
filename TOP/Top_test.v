`timescale 1ns/1ns
module Top_test();
    reg clk = 0, rst;
    wire [15:0]SRAM_DQ;
    wire [17:0]SRAM_ADDR; 
    wire SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;
    Top UUT(.clk(clk), .rst(rst), .SRAM_DQ(SRAM_DQ), .SRAM_ADDR(SRAM_ADDR), .SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N),
            .SRAM_WE_N(SRAM_WE_N), .SRAM_CE_N(SRAM_CE_N), .SRAM_OE_N(SRAM_OE_N));
    SRAM memory(.clk(clk), .rst(rst), .SRAM_DQ(SRAM_DQ), .SRAM_ADDR(SRAM_ADDR), .SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N),
                .SRAM_WE_N(SRAM_WE_N), .SRAM_CE_N(SRAM_CE_N), .SRAM_OE_N(SRAM_OE_N));
    
    always #10 clk = ~clk;

    initial begin
        #2 rst = 1'b1;
        #3 rst = 1'b0;
        #10000 $stop;
    end
endmodule