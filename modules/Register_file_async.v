`timescale 1ns/1ns

module Register_file_async #(parameter WIDTH, parameter LENGTH, parameter MIF_NAME = "mem.mif")
                      (address, par_out);
    parameter ADDRESS_SIZE = $clog2(LENGTH);
    input[ADDRESS_SIZE-1:0] address;
    output [WIDTH-1:0] par_out;

    reg[WIDTH-1:0] mem [0:LENGTH-1];

    assign par_out = mem[address];

    initial begin
        $readmemb(MIF_NAME, mem);
    end
endmodule