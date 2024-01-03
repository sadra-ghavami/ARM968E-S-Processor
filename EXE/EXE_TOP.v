module EXE_TOP (clk, rst, WB_EN_in, WB_EN_out, MEM_R_EN_in, MEM_R_EN_out, MEM_W_EN_in,
                MEM_W_EN_out, status_bits, B, branch_taken, EXE_Dest, EXE_WB_EN,
                EXE_CMD, pc, branch_addr, Val_Rm_in, Val_Rm_out, Val_Rn, imm, car, shift_operand,
                signed_Imm_24, Dest_in, Dest_out, S_in, S_out, alu_result, Sel_src1, Sel_src2,
                MEM_ALU_res, WB_value);

    input clk, rst, WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, S_in, B, imm, car;
    input [1:0] Sel_src1, Sel_src2;
    input[31:0] pc, Val_Rm_in, Val_Rn, MEM_ALU_res, WB_value;
    input[23:0] signed_Imm_24;
    input[11:0] shift_operand;   
    input[3:0] EXE_CMD, Dest_in;
    output MEM_W_EN_out, WB_EN_out, MEM_R_EN_out, S_out, branch_taken, EXE_WB_EN;
    output[3:0] Dest_out, EXE_Dest, status_bits;
    output[31:0] alu_result, branch_addr, Val_Rm_out;

    wire [31:0]val2, Val1, Val_Rm;
    wire Gen_Selector;

    assign WB_EN_out = WB_EN_in;
    assign MEM_R_EN_out = MEM_R_EN_in;
    assign MEM_W_EN_out = MEM_W_EN_in;
    assign Dest_out = Dest_in;
    assign Val_Rm_out = Val_Rm;
    assign branch_taken = B;
    assign EXE_WB_EN = WB_EN_in;
    assign EXE_Dest = Dest_in;
    assign S_out = S_in;

    assign Gen_Selector = MEM_R_EN_in | MEM_W_EN_in;

    EXE_ALU exe_alu(.inp1(Val1), .inp2(val2), .result(alu_result), .EXE_CMD(EXE_CMD), .carry(car), .status_bits(status_bits));
    EXE_Adder exe_adder(.pc(pc), .signed_Imm_24({ {8{signed_Imm_24[23]}}, signed_Imm_24}), .out(branch_addr));
    EXE_Val2_Gen exe_generator(.shift_operand(shift_operand), .imm(imm), .Val_Rm(Val_Rm), .value2(val2), .select(Gen_Selector));
    EXE_MUX3 exe_mux1(.inp1(Val_Rn), .inp2(MEM_ALU_res), .inp3(WB_value), .select(Sel_src1), .out(Val1));
    EXE_MUX3 exe_mux2(.inp1(Val_Rm_in), .inp2(MEM_ALU_res), .inp3(WB_value), .select(Sel_src2), .out(Val_Rm));



endmodule