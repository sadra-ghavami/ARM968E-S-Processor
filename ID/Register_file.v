module Register_file #(parameter DATA_WIDTH = 32, parameter ADDRESS_WIDTH = 4, parameter LENGHT = 15) 
                      (clk, rst, rs1, rs2, WB_Dest, WB_Value, WB_en ,data1, data2);

        input clk, rst, WB_en;
        input [DATA_WIDTH-1:0] WB_Value;
        input [ADDRESS_WIDTH-1:0] rs1, rs2, WB_Dest;
        output [DATA_WIDTH-1:0] data1, data2;

        reg [DATA_WIDTH-1:0] reg_file [0:LENGHT-1];

        integer i;
        always @(negedge clk, posedge rst) begin
                if(rst) begin
                        for(i=0; i<LENGHT; i=i+1) begin
                                reg_file[i] <= 32'b0;
                        end
                end
                else if(WB_en)
                        reg_file[WB_Dest] <= WB_Value;
        end
        
        assign data1 = reg_file[rs1];
        assign data2 = reg_file[rs2];

endmodule