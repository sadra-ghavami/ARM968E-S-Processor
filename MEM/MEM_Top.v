module MEM_Top(clk, rst, WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, ALU_res_in, Dest_in, Val_Rm_in,
               WB_EN_out, MEM_R_EN_out, ALU_res_out, Dest_out, MEM_data_out, FW_ALU_res, mem_ready, SRAM_DQ,
               SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N);
    input clk, rst, WB_EN_in, MEM_R_EN_in, MEM_W_EN_in;
    input[31:0] ALU_res_in, Val_Rm_in;
    input[3:0] Dest_in;
    output WB_EN_out, MEM_R_EN_out;
    output [31:0] FW_ALU_res, ALU_res_out, MEM_data_out;
    output [3:0] Dest_out;

    output mem_ready;

    inout [15:0] SRAM_DQ;
    output [17:0] SRAM_ADDR;
    output  SRAM_UB_N;
    output  SRAM_LB_N;
    output  SRAM_WE_N;
    output  SRAM_CE_N;
    output  SRAM_OE_N;

    wire[31:0] MEM_data;

    Sram_Controller sram(.clk(clk), .rst(rst), .W_EN(MEM_W_EN_in), .R_EN(MEM_R_EN_in), 
                         .address(ALU_res_in), .data_in(Val_Rm_in), .data_out(MEM_data), .ready(mem_ready), .SRAM_DQ(SRAM_DQ),
                         .SRAM_ADDR(SRAM_ADDR), .SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N), .SRAM_WE_N(SRAM_WE_N), .SRAM_CE_N(SRAM_CE_N),
                         .SRAM_OE_N(SRAM_OE_N));
    
    assign Dest_out = Dest_in;
    assign WB_EN_out = WB_EN_in;
    assign MEM_R_EN_out = MEM_R_EN_in;
    assign ALU_res_out = ALU_res_in;
    assign FW_ALU_res = MEM_R_EN_in ? MEM_data : ALU_res_in;
    assign MEM_data_out = MEM_data;

endmodule