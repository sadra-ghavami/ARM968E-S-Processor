`timescale 1ns/1ns

module Register_file_async #(parameter BASE_MEM_WIDTH, parameter WIDTH, parameter ADDRESS_SIZE, parameter LENGTH, parameter MIF_NAME = "mem.txt")
                      (address, par_out);
    input[ADDRESS_SIZE-1:0] address;
    output [WIDTH-1:0] par_out;

    reg[BASE_MEM_WIDTH-1:0] mem [0:LENGTH-1];

    wire[ADDRESS_SIZE-1:0] new_address;
    assign new_address = {address[ADDRESS_SIZE-1:2], 2'b0};
    assign par_out = {mem[new_address], mem[new_address+1], mem[new_address+2], mem[new_address+3]};

    initial begin
        $readmemb(MIF_NAME, mem);
    end
endmodule