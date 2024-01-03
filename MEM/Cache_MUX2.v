module Cache_MUX2(
    input[63:0] inp0, inp1,
    input sel0, sel1,
    output[63:0] out_put
);
    assign out_put = {sel1, sel0} == 2'b01 ? inp0 : {sel1, sel0} == 2'b10 ? inp1 : inp0;

endmodule