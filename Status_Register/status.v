module status_reg(clk,rst,stat_bits,s,carry,stat_bits_reg);
    input [3:0] stat_bits;
    input clk,rst,s;
    output carry;
    output reg [3:0] stat_bits_reg;

    always @(negedge clk, posedge rst) begin
            if(rst)begin
                stat_bits_reg = 4'b0;
            end
            else begin
                if(s) begin
                    stat_bits_reg = stat_bits;
                end
                else begin end
            end
    end

    assign carry = stat_bits_reg[1];
        
endmodule