

module Top(clk, rst, SRAM_DQ, SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N);

input clk, rst;

inout [15:0] SRAM_DQ;
output [17:0] SRAM_ADDR;
output  SRAM_UB_N;
output  SRAM_LB_N;
output  SRAM_WE_N;
output  SRAM_CE_N;
output  SRAM_OE_N;

wire operation_mode;    
wire mem_ready;
wire [31:0] pc4, branch_addr, instr, pc_out_IF_reg, instruction_out_IF_reg;
wire branch_taken,freeze,flush;
assign flush = branch_taken;
wire [3:0] stat_bit_in, stat_bit_out;
wire stat_reg_s, stat_reg_carry;

wire [3:0] WB_Dest, EXE_CND, Dest, Rm_out, Rn_Out;
wire [31:0] WB_val, Val_Rn, Val_Rm;
wire WB_WB_En, WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, Two_Src, imm;
wire [23:0] signed_Imm_24;
wire [11:0] shift_operand;
wire WB_EN_out_ID_reg, MEM_R_EN_out_ID_reg, MEM_W_EN_out_ID_reg, imm_out_ID_reg, S_out_ID_reg, B_out_ID_reg, carry_out_ID_reg, Two_src_out_ID_reg;
wire [3:0] EXE_CND_out_ID_reg, Dest_out_ID_reg, src1_out_ID_reg, src2_out_ID_reg;
wire [31:0] pc_out_ID_reg, Val_Rm_out_ID_reg, Val_Rn_out_ID_reg;
wire [23:0] signed_Imm_24_out_ID_reg;
wire [11:0] shift_operand_out_ID_reg;



//exe part wires
wire WB_EN_OUT_EXE_unit, MEM_R_EN_OUT_EXE_unit, MEM_W_EN_out_EXE_unit, EXE_WB_EN;
wire [3:0] stat_bits_exe_out, EXE_Dest, Dest_out_exe;
wire [31:0] ALU_result_exe, Val_Rm_out_exe;

//exe pipe register wires
wire WB_EN_out_exe_reg, MEM_R_EN_out_exe_reg, MEM_W_EN_out_exe_reg;
wire[1:0] Sel_src1, Sel_src2;
wire[31:0] ALU_res_out_exe_reg, Val_Rm_out_exe_reg;
wire[3:0] Dest_out_exe_reg;

//memory stage wires
wire WB_EN_out_mem_stage, MEM_R_EN_out_mem_stage, MEM_R_EN_DM;
wire [31:0] FW_ALU_res, ALU_res_out_mem_unit, MEM_data_out;
wire[3:0] Dest_out_mem_unit;

//memory stage pipe register wires
wire MEM_R_EN_out_mem_reg, WB_EN_out_mem_reg;
wire [31:0] ALU_res_out_mem_reg, data_out_mem_reg;
wire [3:0] Dest_out_mem_reg;


assign stat_bit_in = stat_bits_exe_out;
assign operation_mode = 1'b1;

IF_Module IF(
    .pc4(pc4), .instr(instr), .branch_addr(branch_addr), 
    .branch_taken(branch_taken), .clk(clk), .rst(rst), .freeze(freeze));

ID_TOP id(
    .clk(clk), .rst(rst), .instruction(instruction_out_IF_reg), .status(stat_bit_out), .WB_Dest(WB_Dest), .WB_Value(WB_val), .WB_WB_En(WB_WB_En), .pc(pc_out_IF_reg), .hazard(freeze),
    .WB_EN(WB_EN), .MEM_R_EN(MEM_R_EN), .MEM_WB_EN(MEM_WB_EN), .EXE_CND(EXE_CND), .S_OUT(S_OUT), .B(B), .Val_Rn(Val_Rn), .Val_Rm(Val_Rm), .signed_Imm_24(signed_Imm_24), .shift_operand(shift_operand),
    .Dest(Dest), .Rm_out(Rm_out), .Rn_Out(Rn_Out), .Two_Src(Two_Src), .imm(imm)
);


EXE_TOP exe(.clk(clk), .rst(rst), .WB_EN_in(WB_EN_out_ID_reg), .WB_EN_out(WB_EN_OUT_EXE_unit), .MEM_R_EN_in(MEM_R_EN_out_ID_reg), .MEM_R_EN_out(MEM_R_EN_OUT_EXE_unit), .MEM_W_EN_in(MEM_W_EN_out_ID_reg),
                .MEM_W_EN_out(MEM_W_EN_out_EXE_unit), .status_bits(stat_bits_exe_out), .B(B_out_ID_reg), .branch_taken(branch_taken), .EXE_Dest(EXE_Dest), .EXE_WB_EN(EXE_WB_EN),
                .EXE_CMD(EXE_CND_out_ID_reg), .pc(pc_out_ID_reg), .branch_addr(branch_addr), .Val_Rm_in(Val_Rm_out_ID_reg), .Val_Rm_out(Val_Rm_out_exe), .Val_Rn(Val_Rn_out_ID_reg), .imm(imm_out_ID_reg), .car(carry_out_ID_reg), .shift_operand(shift_operand_out_ID_reg),
                .signed_Imm_24(signed_Imm_24_out_ID_reg), .Dest_in(Dest_out_ID_reg), .Dest_out(Dest_out_exe), .S_in(S_out_ID_reg), .S_out(stat_reg_s), .alu_result(ALU_result_exe),
                .Sel_src1(Sel_src1), .Sel_src2(Sel_src2), .MEM_ALU_res(FW_ALU_res), .WB_value(WB_val));


WB_TOP wb(.WB_EN_in(WB_EN_out_mem_reg), .MEM_R_EN(MEM_R_EN_out_mem_reg), .ALU_res(ALU_res_out_mem_reg), .MEM_data(data_out_mem_reg), .Dest_in(Dest_out_mem_reg), .WB_Dest(WB_Dest), .WB_Value(WB_val), .WB_EN_out(WB_WB_En));

IF_pipe_register IF_reg(.clk(clk), .rst(rst), .flush(flush), .freeze(freeze), .pc_in(pc4), .instruction_in(instr), .pc_out(pc_out_IF_reg), .instruction_out(instruction_out_IF_reg));

EXE_pipe_register exe_reg(.clk(clk), .rst(rst), .freeze(freeze), .WB_EN_in(WB_EN_OUT_EXE_unit), .MEM_R_EN_in(MEM_R_EN_OUT_EXE_unit), .MEM_W_EN_in(MEM_W_EN_out_EXE_unit), .ALU_res_in(ALU_result_exe), .Val_Rm_in(Val_Rm_out_exe), .Dest_out(Dest_out_exe_reg),
                         .Dest_in(Dest_out_exe), .WB_EN_out(WB_EN_out_exe_reg), .MEM_R_EN_out(MEM_R_EN_out_exe_reg), .MEM_W_EN_out(MEM_W_EN_out_exe_reg), .ALU_res_out(ALU_res_out_exe_reg), .Val_Rm_out(Val_Rm_out_exe_reg));

ID_pipe_register ID_reg(.clk(clk), .rst(rst), .flush(flush), .freeze(freeze), .WB_EN_in(WB_EN), .MEM_R_EN_in(MEM_R_EN), .MEM_W_EN_in(MEM_WB_EN), .imm_in(imm), .EXE_CND_in(EXE_CND), .Dest_in(Dest), .S_in(S_OUT), .B_in(B),
                        .pc_in(pc_out_IF_reg), .Val_Rm_in(Val_Rm), .two_src_in(Two_Src), .src1_in(Rn_Out), .src2_in(Rm_out), .Val_Rn_in(Val_Rn), .signed_Imm_24_in(signed_Imm_24), .shift_operand_in(shift_operand), .WB_EN_out(WB_EN_out_ID_reg),
                        .MEM_R_EN_out(MEM_R_EN_out_ID_reg), .MEM_W_EN_out(MEM_W_EN_out_ID_reg), .imm_out(imm_out_ID_reg), .carry_in(stat_reg_carry), .carry_out(carry_out_ID_reg), .EXE_CND_out(EXE_CND_out_ID_reg), .B_out(B_out_ID_reg), .S_out(S_out_ID_reg), .Dest_out(Dest_out_ID_reg), .pc_out(pc_out_ID_reg), .Val_Rm_out(Val_Rm_out_ID_reg),
                        .Val_Rn_out(Val_Rn_out_ID_reg), .signed_Imm_24_out(signed_Imm_24_out_ID_reg), .shift_operand_out(shift_operand_out_ID_reg), .src1_out(src1_out_ID_reg), .src2_out(src2_out_ID_reg), .two_src_out(Two_src_out_ID_reg));

MEM_Top mem_stage(.clk(clk), .rst(rst), .WB_EN_in(WB_EN_out_exe_reg), .MEM_R_EN_in(MEM_R_EN_out_exe_reg), .MEM_W_EN_in(MEM_W_EN_out_exe_reg), .ALU_res_in(ALU_res_out_exe_reg), .Dest_in(Dest_out_exe_reg), .Val_Rm_in(Val_Rm_out_exe_reg),
               .WB_EN_out(WB_EN_out_mem_stage), .MEM_R_EN_out(MEM_R_EN_out_mem_stage), .ALU_res_out(ALU_res_out_mem_unit), .Dest_out(Dest_out_mem_unit), .MEM_data_out(MEM_data_out), .FW_ALU_res(FW_ALU_res),
               .mem_ready(mem_ready), .SRAM_DQ(SRAM_DQ), .SRAM_ADDR(SRAM_ADDR), .SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N), .SRAM_WE_N(SRAM_WE_N), .SRAM_CE_N(SRAM_CE_N), .SRAM_OE_N(SRAM_OE_N));


MEM_pipe_register MEM_reg(.clk(clk), .rst(rst), .freeze(freeze), .WB_EN_in(WB_EN_out_mem_stage), .MEM_R_EN_in(MEM_R_EN_out_mem_stage), .ALU_res_in(ALU_res_out_mem_unit), .Dest_in(Dest_out_mem_unit), .MEM_data_in(MEM_data_out),
                         .WB_EN_out(WB_EN_out_mem_reg), .MEM_R_EN_out(MEM_R_EN_out_mem_reg), .ALU_res_out(ALU_res_out_mem_reg), .MEM_data_out(data_out_mem_reg), .Dest_out(Dest_out_mem_reg));

status_reg stat_reg(.clk(clk), .rst(rst), .stat_bits(stat_bit_in), .s(stat_reg_s),
                    .carry(stat_reg_carry), .stat_bits_reg(stat_bit_out));

hazard_unit hazard_detector(.MEM_Dest(Dest_out_mem_unit), .MEM_WB_EN(WB_EN_out_mem_stage), .EXE_Dest(EXE_Dest), .EXE_WB_EN(EXE_WB_EN), .Rn(Rn_Out),
                            .Two_src(Two_Src), .Hazard(freeze), .Rm_out(Rm_out), .operation_mode(operation_mode), .MEM_W_EN(MEM_W_EN_out_exe_reg),
                            .MEM_R_EN(MEM_R_EN_out_exe_reg), .mem_ready(mem_ready));
                            
Forwarding_unit forward_detector(.MEM_Dest(Dest_out_exe_reg), .MEM_WB_EN(WB_EN_out_exe_reg), .WB_Dest(Dest_out_mem_reg),
                                 .WB_WB_EN(WB_EN_out_mem_reg), .Rn_src(src1_out_ID_reg), .Rm_src(src2_out_ID_reg), 
                                 .Two_src(Two_src_out_ID_reg), .operation_mode(operation_mode), .src1_sel(Sel_src1), .src2_sel(Sel_src2));

endmodule