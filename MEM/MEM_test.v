module MEM_test();
    reg clk = 1'b0, rst = 1'b0, W_EN, R_EN;
    reg[31:0] address, data_in;
    wire[31:0] data_out;

    Data_Memory UUT(clk, rst, W_EN, R_EN, address, data_in, data_out);

    always #10 clk <= ~clk;

    initial begin
        #2 rst = 1'b1;
           W_EN = 1'b0;
           R_EN = 1'b0;
        #3 rst = 1'b0;
        
        #20 address = 32'd1024;
            data_in = 32'd1;
            W_EN = 1'b1;

        #20 address = 32'd1028;
            data_in = 32'd2;

        #20 address = 32'd1032;
            data_in = 32'd3;

        #20 W_EN = 1'b0;

        #20 R_EN = 1'b1;
            address = 32'd1025;

        #7 address = 32'd1030;

        #7 address = 32'd1035;

        #20 $stop;

    end
endmodule