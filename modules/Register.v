`timescale  1ns/1ns

module Register#(parameter WIDTH)
    (clk, rst, load, clear, par_in, par_out);
    input clk, rst, load, clear;
    input[WIDTH-1:0] par_in;
    output reg[WIDTH-1:0] par_out;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            par_out <= 0;
        end
        else if(clear) begin
            par_out <= 0;
        end
        else if(load) begin
            par_out <= par_in;
        end
        else;
    end

endmodule