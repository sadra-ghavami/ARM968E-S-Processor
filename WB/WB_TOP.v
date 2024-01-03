module WB_TOP(WB_EN_in, MEM_R_EN, ALU_res, MEM_data, Dest_in, WB_Dest, WB_Value, WB_EN_out);
    input WB_EN_in, MEM_R_EN;
    input[31:0] ALU_res, MEM_data;
    input[3:0] Dest_in;

    output[31:0] WB_Value;
    output[3:0] WB_Dest;
    output WB_EN_out;

    assign WB_EN_out = WB_EN_in;
    assign WB_Dest = Dest_in;
    MUX2 #(.WIDTH(32)) mux(.input0(ALU_res), .input1(MEM_data), .select(MEM_R_EN), .out_put(WB_Value));

endmodule