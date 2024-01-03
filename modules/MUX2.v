`timescale 1ns/1ns

module MUX2 #(parameter WIDTH)
       (input0, input1, select, out_put);

    input[WIDTH-1:0] input0, input1;
    input select;
    output[WIDTH-1:0] out_put;

    assign out_put = select ? input1 : input0;

endmodule