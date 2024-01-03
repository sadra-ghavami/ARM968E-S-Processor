module EXE_MUX3(inp1, inp2, inp3, select, out);
    parameter WIDTH = 32;
    input[WIDTH-1:0] inp1, inp2, inp3;
    input[1:0] select;
    output[WIDTH-1:0] out;

    assign out = (select == 2'b00) ? inp1:
                 (select == 2'b01) ? inp2:
                 (select == 2'b10) ? inp3: inp1;
endmodule