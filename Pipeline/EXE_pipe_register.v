module EXE_pipe_register(clk, rst, freeze, WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, ALU_res_in, Val_Rm_in, Dest_out,
                         Dest_in, WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, ALU_res_out, Val_Rm_out);
    input clk, rst, freeze, WB_EN_in, MEM_R_EN_in, MEM_W_EN_in;
    input[31:0] ALU_res_in, Val_Rm_in;
    input[3:0] Dest_in;
    output reg WB_EN_out, MEM_R_EN_out, MEM_W_EN_out;
    output reg[31:0] ALU_res_out, Val_Rm_out;
    output reg[3:0] Dest_out;

    always @(posedge clk, posedge rst)begin
        if(rst)
            {WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, ALU_res_out, Val_Rm_out, Dest_out} = 0;
        else if(~freeze) begin
            WB_EN_out <= WB_EN_in; MEM_R_EN_out <= MEM_R_EN_in; MEM_W_EN_out <= MEM_W_EN_in;
            ALU_res_out <= ALU_res_in; Val_Rm_out <= Val_Rm_in; Dest_out <= Dest_in;
        end
        else;
    end
endmodule