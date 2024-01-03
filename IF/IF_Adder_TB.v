`timescale 1ns/1ns

module IF_Adder_tb (
);
    reg [9:0] in_pc;
    reg [2:0] static_num;
    wire [9:0]out_pc;

    IF_Adder cut(static_num,in_pc,out_pc);

    initial begin
        #10 static_num = 3'b100;
        in_pc = 10'd100;
        #30 static_num = 3'b111;
        in_pc = 10'd150;
        #100 $stop;
    end

endmodule