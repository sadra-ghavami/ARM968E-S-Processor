`timescale  1ns/1ns

module regfile_test();

    reg[2:0] address;
    wire[31:0] par_out;

    Register_file_async #(.WIDTH(32), .LENGTH(8)) UUT(.address(address), .par_out(par_out));
    integer i;
    initial begin
        for(i=0 ; i<8; i = i+1) begin
            #10 address = i;
        end
        #10 $stop;
    end

endmodule