module IF_pipe_register(clk, rst, flush, freeze, pc_in, instruction_in, pc_out, instruction_out);
    input clk, rst, flush, freeze;
    input[31:0] pc_in, instruction_in;
    output reg[31:0] pc_out, instruction_out;

    always @(posedge clk, posedge rst) begin
        if(rst)
            {pc_out, instruction_out} = 64'b0;
        else if(freeze);
        else if(flush)
            {pc_out, instruction_out} = 64'b0;
        else if(~freeze) begin
            pc_out <= pc_in;
            instruction_out <= instruction_in;
        end
        else;
    end

endmodule