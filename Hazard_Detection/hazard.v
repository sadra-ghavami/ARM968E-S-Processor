module hazard_unit(MEM_Dest, MEM_WB_EN, EXE_Dest, EXE_WB_EN, Rn, Two_src, Hazard, Rm_out, operation_mode, MEM_W_EN, MEM_R_EN, mem_ready);
    input [3:0] Rn, EXE_Dest, MEM_Dest, Rm_out;
    input MEM_WB_EN, EXE_WB_EN, Two_src, operation_mode, mem_ready, MEM_R_EN, MEM_W_EN;
    output Hazard;

    assign Hazard = (MEM_W_EN | MEM_R_EN) & ~mem_ready;
    // assign Hazard = ~operation_mode ? (EXE_WB_EN && (Rn == EXE_Dest)) || (MEM_WB_EN && (Rn == MEM_Dest)) ||
                                    //   (EXE_WB_EN && Two_src && (Rm_out == EXE_Dest)) || (MEM_WB_EN && Two_src && (Rm_out == MEM_Dest)) 
                                    //    ? 1'b1 : 1'b0 :
                    // operation_mode  ? 1'b0 : 1'b0;

            
endmodule