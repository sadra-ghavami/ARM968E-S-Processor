`define pc_size 32
`define data_size 32

module IF_Module (
    pc4,instr,branch_addr,branch_taken,clk,rst,freeze
);
    inout [`pc_size-1:0] pc4; 
    input [`pc_size-1:0] branch_addr;
    input branch_taken,clk,rst,freeze;
    output [`data_size-1:0] instr;

    wire [`pc_size-1:0] pc,pci;

    MUX2 #(.WIDTH(32)) mx1 (pc4,branch_addr,branch_taken,pc);
    Register #(.WIDTH(32)) pc_reg (.clk(clk), .rst(rst), .freeze(freeze), .par_in(pc), .par_out(pci));
    assign pc4 = pci + 4;
    Register_file_async #(.BASE_MEM_WIDTH(8), .WIDTH(`pc_size) , .LENGTH(376), .ADDRESS_SIZE(`pc_size), .MIF_NAME("mem.txt")) inst_mem (pci,instr);

endmodule