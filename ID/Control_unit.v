module Control_unit(opcode, mode, S, control_signals);
    input[3:0] opcode;
    input S;
    input[1:0] mode;
    output [8:0] control_signals;

    localparam[3:0] MOV = 4'b1101, MVN = 4'b1111, ADD = 4'b0100, ADC = 4'b0101, SUB = 4'b0010,
                    SBC = 4'b0110, AND = 4'b0000, ORR = 4'b1100, EOR = 4'b0001, CMP = 4'b1010,
                    TST = 4'b1000, LDR_STR = 4'b0100;

    localparam[1:0] BRANCH = 2'b10, REG_INST = 2'b01, SHIFT_OP = 2'b00;

    reg WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B;
    reg[3:0] EXE_CND;

    // upside-down binding
    assign control_signals = {WB_EN, MEM_R_EN, MEM_WB_EN, EXE_CND, B, S};
    
    always @(opcode, mode, S) begin
        {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0000};
        case(mode)
            BRANCH: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0000};
            REG_INST: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = S ? {1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0010}:
                                                                            {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0010};
            SHIFT_OP:case(opcode)
                        MOV: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b1, 1'b0, 1'b0, S, 1'b0, 4'b0001};
                        MVN: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b1, 1'b0, 1'b0, S, 1'b0, 4'b1001};
                        ADD: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b1, 1'b0, 1'b0, S, 1'b0, 4'b0010};
                        ADC: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b1, 1'b0, 1'b0, S, 1'b0, 4'b0011};
                        SUB: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b1, 1'b0, 1'b0, S, 1'b0, 4'b0100};
                        SBC: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b1, 1'b0, 1'b0, S, 1'b0, 4'b0101};
                        AND: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b1, 1'b0, 1'b0, S, 1'b0, 4'b0110};
                        ORR: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b1, 1'b0, 1'b0, S, 1'b0, 4'b0111};
                        EOR: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b1, 1'b0, 1'b0, S, 1'b0, 4'b1000};
                        CMP: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0100};
                        TST: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0110};
                        default: {WB_EN, MEM_R_EN, MEM_WB_EN, S_OUT, B, EXE_CND} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0000};
                    endcase
        endcase
    end

endmodule