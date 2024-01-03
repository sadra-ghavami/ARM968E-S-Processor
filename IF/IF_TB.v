`timescale 1ns/1ns

module IF_TB (
);
    wire [31:0] pc4;
    reg [31:0] branch_addr;
    reg branch_taken,clk =0 ,rst=0,freeze=0, flush=0;
    wire [31:0] instr;

    IF_Module UUT(pc4,instr,branch_addr,branch_taken,clk,rst,freeze,flush);

    always #10 clk = ~clk;

    initial begin
        #2 rst = 1'b1;
        #5 rst = 1'b0; branch_addr = 32'd0; branch_taken = 1'b0; freeze = 1'b0;
        #120 branch_taken = 1'b1; branch_addr = 32'd12;
        #20 branch_taken = 1'b0;
        #200 $stop;
    end

endmodule