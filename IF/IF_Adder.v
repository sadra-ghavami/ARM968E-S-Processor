module IF_Adder (
    static_inp, pc_inp, pc_out
);

input [2:0] static_inp;
input [9:0] pc_inp;
output [9:0] pc_out;
assign pc_out = static_inp + pc_inp;

endmodule