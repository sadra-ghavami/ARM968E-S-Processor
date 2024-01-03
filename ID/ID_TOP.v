module ID_TOP (
    clk, rst, instruction, status, WB_Dest, WB_Value, WB_WB_En, pc, hazard, WB_EN,
    MEM_R_EN, MEM_WB_EN, EXE_CND, S_OUT, B, Val_Rn, Val_Rm, signed_Imm_24, shift_operand,
    Dest, Rm_out, Rn_Out, Two_Src, imm
);
    input clk, rst, hazard, WB_WB_En;
    input [31:0] instruction, WB_Value;
    input [3:0] status, WB_Dest;
    inout [31:0] pc;
    output WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, Two_Src, imm;
    output [31:0] Val_Rm, Val_Rn;
    inout [23:0] signed_Imm_24;
    output [3:0] EXE_CND, Rm_out, Rn_Out, Dest;
    output [11:0] shift_operand;

    wire [3:0] cond, OpCode, Rn, Rd, Rm;
    wire [3:0] RM_mid;
    wire [1:0] Mode;
    wire S, Im, z, c, n, v;
    wire Out_Cond, MEM_WB_mux_select;
    wire [8:0] ctrl_output;
    wire [8:0] command;

    wire output_mux_selector;
    wire Rm_mid_selector;
    assign Rm_mid_selector = command[6];
    assign Rm_out = RM_mid;
    assign Rn_Out = instruction[19:16];
    assign Rn = instruction[19:16];
    assign Rm = instruction[3:0];
    assign Rd = instruction[15:12];
    assign Im = instruction[25];
    assign S = instruction[20];
    assign cond = instruction[31:28];
    assign {n, z, c, v} = status[3:0];
    assign OpCode = instruction[24:21];
    assign Mode = instruction[27:26];
    assign shift_operand = instruction[11:0];
    assign signed_Imm_24 = instruction[23:0];
    assign imm = instruction[25];
    assign Dest = instruction[15:12];
    assign MEM_WB_mux_select = ctrl_output[6];

    MUX2 #(4) m1(Rm, Rd, MEM_WB_mux_select, RM_mid);
    Register_file RF(clk, rst, Rn, RM_mid, WB_Dest, WB_Value, WB_WB_En ,Val_Rn, Val_Rm);
    assign Two_Src = (~Im | MEM_WB_EN);
    Condition_Check cnd_check(cond,z,c,n,v,Out_Cond);
    assign output_mux_selector = (~Out_Cond | hazard);
    Control_unit ctrl_unit (OpCode, Mode, S, ctrl_output);
    MUX2 #(9) m2(ctrl_output, 9'b0, output_mux_selector, command);

    assign {WB_EN, MEM_R_EN, MEM_WB_EN, EXE_CND, B, S_OUT} = command[8:0];

endmodule