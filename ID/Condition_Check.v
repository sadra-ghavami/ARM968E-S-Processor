module Condition_Check (
    cond,z,c,n,v,Out_Cond
);
    input [3:0] cond;
    input z,c,n,v;
    output reg Out_Cond;

    always @(cond,z,c,n,v) begin
        case (cond)
        //EQ
            4'b0000: Out_Cond = z ? 1'b1 : 1'b0;
        //NE
            4'b0001: Out_Cond = z ? 1'b0 : 1'b1;
        //CS/HS 
            4'b0010: Out_Cond = c ? 1'b1 : 1'b0;
        //CC/LO    
            4'b0011: Out_Cond = c ? 1'b0 : 1'b1;
        //MI    
            4'b0100: Out_Cond = n ? 1'b1 : 1'b0;
        //PL    
            4'b0101: Out_Cond = n ? 1'b0 : 1'b1;
        //VS    
            4'b0110: Out_Cond = v ? 1'b1 : 1'b0;
        //VC    
            4'b0111: Out_Cond = v ? 1'b0 : 1'b1;
        //HI    
            4'b1000: Out_Cond = (c&~z) ? 1'b1 : 1'b0;
        //LS    
            4'b1001: Out_Cond = (~c&z) ? 1'b1 : 1'b0;
        //GE    
            4'b1010: Out_Cond = (v == n) ? 1'b1 : 1'b0;
        //LT    
            4'b1011: Out_Cond = (v != n) ? 1'b1 : 1'b0;
        //GT    
            4'b1100: Out_Cond = (z | (n==v)) ? 1'b1 : 1'b0;
        //LE    
            4'b1101: Out_Cond = (z | (n!=v)) ? 1'b1 : 1'b0;
        //AL    
            4'b1110: Out_Cond = 1'b1;
        //DONT CARE    
            4'b1111: Out_Cond = 1'b1;
        //DEFAULT
            default: Out_Cond = 1'b0;
        endcase
        
    end
endmodule