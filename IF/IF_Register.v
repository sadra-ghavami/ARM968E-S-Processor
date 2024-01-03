`define pc_size 32
`define data_size 32

module IF_st_Reg (
    clk,rst,inp1,inp2,freeze,out1,out2
);
    input [`pc_size-1 : 0] inp1;
    input [`data_size-1 : 0] inp2;
    input clk,rst,freeze;
    output reg [`pc_size-1 : 0] out1;
    output reg [`data_size-1 : 0] out2;

    always @(posedge clk, posedge rst) begin
      if(rst) begin
        out1 = `pc_size'd0;
        out2 = `data_size'd0;
      end
      else if(~freeze) begin
        out1 <= inp1;
        out2 <= inp2;
      end
    end
    endmodule