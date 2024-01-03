module Forwarding_unit(MEM_Dest, MEM_WB_EN, WB_Dest, WB_WB_EN, Rn_src, Rm_src, Two_src, operation_mode, src1_sel, src2_sel);

    input [3:0] MEM_Dest, WB_Dest, Rn_src, Rm_src;
    input MEM_WB_EN, WB_WB_EN, Two_src, operation_mode;
    output [1:0] src1_sel, src2_sel;

    assign src1_sel = ~operation_mode ? 2'b00 :
                        (MEM_WB_EN && (Rn_src == MEM_Dest)) ? 2'b01 : //memory forwarding
                        (WB_WB_EN && (Rn_src == WB_Dest)) ? 2'b10 : //write back forwarding
                        2'b00;//don't need forwarding
    assign src2_sel = ~operation_mode ? 2'b00 :
                        (MEM_WB_EN  && Two_src && (Rm_src == MEM_Dest)) ? 2'b01 : //memory forwarding
                        (WB_WB_EN  && Two_src && (Rm_src == WB_Dest)) ? 2'b10 : //write back forwarding
                        2'b00;//don't need forwarding     
endmodule