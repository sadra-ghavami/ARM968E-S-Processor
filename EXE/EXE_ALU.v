module EXE_ALU(inp1, inp2, result, EXE_CMD, carry, status_bits);
    parameter WIDTH = 32;
    input[WIDTH-1:0] inp1, inp2;
    input[3:0] EXE_CMD;
    input carry;
    output [WIDTH-1:0] result;
    output [3:0] status_bits;
    wire Cout, N, Z, C, V;

    assign {Cout,result} = (EXE_CMD == 4'b0001) ? inp2 : //mov
                    (EXE_CMD == 4'b1001) ? ~inp2 : //mvn
                    (EXE_CMD == 4'b0010) ? inp2 + inp1 : //add & ldr & str
                    (EXE_CMD == 4'b0011) ? inp1 + inp2 + carry ://adc
                    (EXE_CMD == 4'b0100) ? inp1 - inp2 : //sub & cmp
                    (EXE_CMD == 4'b0101) ? (inp1 - inp2) - {31'd0, ~carry} : // sbc
                    (EXE_CMD == 4'b0110) ? inp1 & inp2 : //and & tst
                    (EXE_CMD == 4'b0111) ? inp1 | inp2 : //orr
                    (EXE_CMD == 4'b1000) ? inp1 ^ inp2 : 0; //eor 
    
    assign Z = (result == 0) ? 1'b1 : 1'b0;
    assign N = result[WIDTH-1];
    assign C = Cout;
    assign V =  (EXE_CMD == 4'b0001) ? 1'b0 : //mov
                (EXE_CMD == 4'b1001) ? 1'b0 : //mvn
                (EXE_CMD == 4'b0010) ? ~(inp1[WIDTH-1] ^ inp2[WIDTH-1]) & (inp1[WIDTH-1] ^ result[WIDTH-1]): //add & ldr & str
                (EXE_CMD == 4'b0011) ? ~(inp1[WIDTH-1] ^ inp2[WIDTH-1]) & (inp1[WIDTH-1] ^ result[WIDTH-1])://adc
                (EXE_CMD == 4'b0100) ? (inp1[WIDTH-1] ^ inp2[WIDTH-1]) & (inp1[WIDTH-1] ^ result[WIDTH-1]): //sub & cmp
                (EXE_CMD == 4'b0101) ? (inp1[WIDTH-1] ^ inp2[WIDTH-1]) & (inp1[WIDTH-1] ^ result[WIDTH-1]): // sbc
                (EXE_CMD == 4'b0110) ? 1'b0 : //and & tst
                (EXE_CMD == 4'b0111) ? 1'b0 : //orr
                (EXE_CMD == 4'b1000) ? 1'b0 : 1'b0; //eor    
    assign status_bits = {N, Z, C, V};         
endmodule