`timescale 1ns/1ns

module ID_test2();
    reg clk = 1'b0, rst = 1'b0;
    reg [31:0] test_inst;

    wire WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, Two_Src, imm;

    wire [31:0] Val_Rm, Val_Rn;

    wire [23:0] signed_Imm_24;

    wire [3:0] EXE_CND, Rm, Rn_Out, Dest;

    wire [11:0] shift_operand;

    wire [31:0] test_pc;
    

    ID_TOP CUt1(.clk(clk), .rst(rst), .instruction(test_inst), .pc(test_pc), .hazard(1'b0), .WB_WB_En(1'b0),
                    .WB_Value(32'b0), .status(4'b0), .WB_Dest(4'b0), .WB_EN(WB_EN), .MEM_R_EN(MEM_R_EN), .MEM_WB_EN(MEM_WB_EN),
                    .S_OUT(S_OUT), .B(B), .Two_Src(Two_Src), .Val_Rm(Val_Rm), .Val_Rn(Val_Rn), .signed_Imm_24(signed_Imm_24),
                    .EXE_CND(EXE_CND), .Rm_out(Rm), .Rn_Out(Rn_Out), .shift_operand(shift_operand), .Dest(Dest), .imm(imm));


    always #10 clk = ~clk;

    

   

    initial begin
        #3 rst = 1'b1;
        #3 rst = 1'b0;

        #20 test_inst = 32'b1110_00_1_1101_0_0000_0000_000000010100; //MOV		R0 ,#20 		//R0 = 20

        #100 test_inst = 32'b1110_00_1_1101_0_0000_0001_101000000001; //MOV		R1 ,#4096		//R1 = 4096

        #100 test_inst = 32'b1110_00_1_1101_0_0000_0010_000100000011; //MOV		R2 ,#0xC0000000	//R2 = -1073741824
        #100 test_inst =	32'b1110_00_0_0100_1_0010_0011_000000000010; //ADDS		R3 ,R2,R2		//R3 = -2147483648 
        #100 test_inst =	32'b1110_00_0_0101_0_0000_0100_000000000000; //ADC		R4 ,R0,R0		//R4 = 41
        #100 test_inst =	32'b1110_00_0_0010_0_0100_0101_000100000100; //SUB		R5 ,R4,R4,LSL #2	//R5 = -123
        #100 test_inst =	32'b1110_00_0_0110_0_0000_0110_000010100000; //SBC		R6 ,R0,R0,LSR #1	//R6 = 10
        #100 test_inst =	32'b1110_00_0_1100_0_0101_0111_000101000010; //ORR		R7 ,R5,R2,ASR #2	//R7 = -123
        #100 test_inst =	32'b1110_00_0_0000_0_0111_1000_000000000011; //AND		R8 ,R7,R3		//R8 = -2147483648
        #100 test_inst =	32'b1110_00_0_1111_0_0000_1001_000000000110; //MVN		R9 ,R6		//R9 = -11
        #100 test_inst =	32'b1110_00_0_0001_0_0100_1010_000000000101; //EOR		R10,R4,R5	//R10 = -84
        #100 test_inst =	32'b1110_00_0_1010_1_1000_0000_000000000110; //CMP		R8 ,R6		
        #100 test_inst =	32'b0001_00_0_0100_0_0001_0001_000000000001; //ADDNE		R1 ,R1,R1		//R1 = 8192
        #100 test_inst =	32'b1110_00_0_1000_1_1001_0000_000000001000; //TST		R9 ,R8		
        #100 test_inst =	32'b0000_00_0_0100_0_0010_0010_000000000010; //ADDEQ		R2 ,R2,R2   	//R2 = -1073741824
        #100 test_inst =	32'b1110_00_1_1101_0_0000_0000_101100000001; //MOV		R0 ,#1024		//R0 = 1024
        #100 test_inst =	32'b1110_01_0_0100_0_0000_0001_000000000000; //STR		R1 ,[R0],#0	//MEM[1024] = 8192
        #100 test_inst =	32'b1110_01_0_0100_1_0000_1011_000000000000; //LDR		R11,[R0],#0	//R11 = 8192


        #100 $stop;
    end
endmodule