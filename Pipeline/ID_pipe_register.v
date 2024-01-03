module ID_pipe_register(clk, rst, freeze, flush, WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, two_src_in, imm_in, S_in, B_in, EXE_CND_in, Dest_in,
                        pc_in, Val_Rm_in, Val_Rn_in, src1_in, src2_in, signed_Imm_24_in, shift_operand_in, carry_in, carry_out, WB_EN_out,
                        MEM_R_EN_out, MEM_W_EN_out, two_src_out, src1_out, src2_out, imm_out, S_out, B_out, EXE_CND_out, Dest_out, pc_out, Val_Rm_out,
                        Val_Rn_out, signed_Imm_24_out, shift_operand_out);
    input clk, rst, flush, freeze, WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, imm_in, S_in, B_in, carry_in, two_src_in;
    input[3:0] EXE_CND_in, Dest_in, src1_in, src2_in;
    input[31:0] pc_in, Val_Rm_in, Val_Rn_in;
    input[23:0] signed_Imm_24_in;
    input[11:0] shift_operand_in;
    output reg WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, imm_out, S_out, B_out, carry_out, two_src_out;
    output reg[3:0] EXE_CND_out, Dest_out, src1_out, src2_out;
    output reg[31:0] pc_out, Val_Rm_out, Val_Rn_out;
    output reg[23:0] signed_Imm_24_out;
    output reg[11:0] shift_operand_out;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            {WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, imm_out, EXE_CND_out, S_out, B_out, carry_out, two_src_out} = 0; 
            {Dest_out, pc_out, Val_Rm_out, Val_Rn_out, signed_Imm_24_out, shift_operand_out, src1_out, src2_out} = 0;
        end
        else if(freeze);
        else if(flush)begin
            {WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, imm_out, EXE_CND_out, S_out, B_out, carry_out, two_src_out} = 0; 
            {Dest_out, pc_out, Val_Rm_out, Val_Rn_out, signed_Imm_24_out, shift_operand_out, src1_out, src2_out} = 0;
        end
        else if(~freeze) begin
            WB_EN_out <= WB_EN_in; MEM_W_EN_out <= MEM_W_EN_in; MEM_R_EN_out <= MEM_R_EN_in; imm_out <= imm_in;
            EXE_CND_out <= EXE_CND_in; S_out <= S_in; B_out <= B_in; Dest_out <= Dest_in; pc_out <= pc_in; carry_out <= carry_in; Val_Rm_out <= Val_Rm_in;
            signed_Imm_24_out <= signed_Imm_24_in; shift_operand_out <= shift_operand_in;
            Val_Rn_out <= Val_Rn_in; two_src_out <= two_src_in; src1_out <= src1_in; src2_out <= src2_in;
        end
        else; 
    end
endmodule