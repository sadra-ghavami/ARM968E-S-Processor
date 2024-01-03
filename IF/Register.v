`timescale  1ns/1ns

module Register#(parameter WIDTH)
    (clk, rst, par_in, par_out, freeze);
    input clk, rst, freeze;
    input[WIDTH-1:0] par_in;
    output reg[WIDTH-1:0] par_out;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            par_out <= 0;
        end
        else if(freeze);
        else
            par_out <= par_in;
    end

endmodule