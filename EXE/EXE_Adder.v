module EXE_Adder(pc, signed_Imm_24, out);
    parameter WIDTH = 32;
    input[WIDTH-1:0] pc, signed_Imm_24;
    output[WIDTH-1:0] out;

    assign out = pc + {signed_Imm_24[29:0], 2'b00};
endmodule