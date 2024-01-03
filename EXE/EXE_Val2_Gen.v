module EXE_Val2_Gen(shift_operand, imm, Val_Rm, value2, select);
    input[31:0] Val_Rm;
    input[11:0] shift_operand;
    input imm, select;
    output[31:0] value2;

    wire[7:0] immed_8;
    wire[3:0] rotate_imm;
    wire[63:0] double_data_imm, double_Val_Rm, arithmetic_shift_data;
    wire[1:0] shift;
    wire[4:0] shift_imm;
    wire[31:0] shifted_value;

    assign shift = shift_operand[6:5];
    assign shift_imm = shift_operand[11:7];
    assign rotate_imm = shift_operand[11:8];
    assign immed_8 = shift_operand[7:0];
    assign double_data_imm = {24'b0, immed_8, 24'b0, immed_8};
    assign double_Val_Rm = {Val_Rm, Val_Rm};
    assign arithmetic_shift_data = {{32{Val_Rm[31]}}, Val_Rm};

    assign shifted_value = imm ? rotate_imm == 4'h0 ? double_data_imm[31:0]  :
                                 rotate_imm == 4'h1 ? double_data_imm[33:2]  :
                                 rotate_imm == 4'h2 ? double_data_imm[35:4]  :
                                 rotate_imm == 4'h3 ? double_data_imm[37:6]  :
                                 rotate_imm == 4'h4 ? double_data_imm[39:8]  :
                                 rotate_imm == 4'h5 ? double_data_imm[41:10] :
                                 rotate_imm == 4'h6 ? double_data_imm[43:12] :
                                 rotate_imm == 4'h7 ? double_data_imm[45:14] :
                                 rotate_imm == 4'h8 ? double_data_imm[47:16] :
                                 rotate_imm == 4'h9 ? double_data_imm[49:18] :
                                 rotate_imm == 4'ha ? double_data_imm[41:20] :
                                 rotate_imm == 4'hb ? double_data_imm[43:22] :
                                 rotate_imm == 4'hc ? double_data_imm[45:24] :
                                 rotate_imm == 4'hd ? double_data_imm[47:26] :
                                 rotate_imm == 4'he ? double_data_imm[49:28] :
                                 rotate_imm == 4'hf ? double_data_imm[51:30] : 
                                                      double_data_imm[31:0]  :

                                 shift == 2'b00 ? Val_Rm << shift_imm  :
                                 shift == 2'b01 ? Val_Rm >> shift_imm  :
                        
                                 shift == 2'b10 ? shift_imm == 5'h00 ? arithmetic_shift_data[31:0] :
                                                  shift_imm == 5'h01 ? arithmetic_shift_data[32:1] :
                                                  shift_imm == 5'h02 ? arithmetic_shift_data[33:2] :
                                                  shift_imm == 5'h03 ? arithmetic_shift_data[34:3] :
                                                  shift_imm == 5'h04 ? arithmetic_shift_data[35:4] :
                                                  shift_imm == 5'h05 ? arithmetic_shift_data[36:5] :
                                                  shift_imm == 5'h06 ? arithmetic_shift_data[37:6] :
                                                  shift_imm == 5'h07 ? arithmetic_shift_data[38:7] :
                                                  shift_imm == 5'h08 ? arithmetic_shift_data[39:8] :
                                                  shift_imm == 5'h09 ? arithmetic_shift_data[40:9] :
                                                  shift_imm == 5'h0a ? arithmetic_shift_data[41:10]:
                                                  shift_imm == 5'h0b ? arithmetic_shift_data[42:11]:
                                                  shift_imm == 5'h0c ? arithmetic_shift_data[43:12]:
                                                  shift_imm == 5'h0d ? arithmetic_shift_data[44:13]:
                                                  shift_imm == 5'h0e ? arithmetic_shift_data[45:14]:
                                                  shift_imm == 5'h0f ? arithmetic_shift_data[46:15]:
                                                  shift_imm == 5'h10 ? arithmetic_shift_data[47:16]:
                                                  shift_imm == 5'h11 ? arithmetic_shift_data[48:17]:
                                                  shift_imm == 5'h12 ? arithmetic_shift_data[49:18]:
                                                  shift_imm == 5'h13 ? arithmetic_shift_data[50:19]:
                                                  shift_imm == 5'h14 ? arithmetic_shift_data[51:20]:
                                                  shift_imm == 5'h15 ? arithmetic_shift_data[52:21]:
                                                  shift_imm == 5'h16 ? arithmetic_shift_data[53:22]:
                                                  shift_imm == 5'h17 ? arithmetic_shift_data[54:23]:
                                                  shift_imm == 5'h18 ? arithmetic_shift_data[55:24]:
                                                  shift_imm == 5'h19 ? arithmetic_shift_data[56:25]:
                                                  shift_imm == 5'h1a ? arithmetic_shift_data[57:26]:
                                                  shift_imm == 5'h1b ? arithmetic_shift_data[58:27]:
                                                  shift_imm == 5'h1c ? arithmetic_shift_data[59:28]:
                                                  shift_imm == 5'h1d ? arithmetic_shift_data[60:29]:
                                                  shift_imm == 5'h1e ? arithmetic_shift_data[61:30]:
                                                  shift_imm == 5'h1f ? arithmetic_shift_data[62:31]: 
                                                                       arithmetic_shift_data[31:0] :

                                 shift == 2'b11 ? shift_imm == 5'h00 ? double_Val_Rm[31:0] :
                                                  shift_imm == 5'h01 ? double_Val_Rm[32:1] :
                                                  shift_imm == 5'h02 ? double_Val_Rm[33:2] :
                                                  shift_imm == 5'h03 ? double_Val_Rm[34:3] :
                                                  shift_imm == 5'h04 ? double_Val_Rm[35:4] :
                                                  shift_imm == 5'h05 ? double_Val_Rm[36:5] :
                                                  shift_imm == 5'h06 ? double_Val_Rm[37:6] :
                                                  shift_imm == 5'h07 ? double_Val_Rm[38:7] :
                                                  shift_imm == 5'h08 ? double_Val_Rm[39:8] :
                                                  shift_imm == 5'h09 ? double_Val_Rm[40:9] :
                                                  shift_imm == 5'h0a ? double_Val_Rm[41:10]:
                                                  shift_imm == 5'h0b ? double_Val_Rm[42:11]:
                                                  shift_imm == 5'h0c ? double_Val_Rm[43:12]:
                                                  shift_imm == 5'h0d ? double_Val_Rm[44:13]:
                                                  shift_imm == 5'h0e ? double_Val_Rm[45:14]:
                                                  shift_imm == 5'h0f ? double_Val_Rm[46:15]:
                                                  shift_imm == 5'h10 ? double_Val_Rm[47:16]:
                                                  shift_imm == 5'h11 ? double_Val_Rm[48:17]:
                                                  shift_imm == 5'h12 ? double_Val_Rm[49:18]:
                                                  shift_imm == 5'h13 ? double_Val_Rm[50:19]:
                                                  shift_imm == 5'h14 ? double_Val_Rm[51:20]:
                                                  shift_imm == 5'h15 ? double_Val_Rm[52:21]:
                                                  shift_imm == 5'h16 ? double_Val_Rm[53:22]:
                                                  shift_imm == 5'h17 ? double_Val_Rm[54:23]:
                                                  shift_imm == 5'h18 ? double_Val_Rm[55:24]:
                                                  shift_imm == 5'h19 ? double_Val_Rm[56:25]:
                                                  shift_imm == 5'h1a ? double_Val_Rm[57:26]:
                                                  shift_imm == 5'h1b ? double_Val_Rm[58:27]:
                                                  shift_imm == 5'h1c ? double_Val_Rm[59:28]:
                                                  shift_imm == 5'h1d ? double_Val_Rm[60:29]:
                                                  shift_imm == 5'h1e ? double_Val_Rm[61:30]:
                                                  shift_imm == 5'h1f ? double_Val_Rm[62:31]: 
                                                                       double_Val_Rm[31:0] :
                            32'b0;

    assign value2 = select ? {20'b0, shift_operand} : shifted_value;

                        

endmodule