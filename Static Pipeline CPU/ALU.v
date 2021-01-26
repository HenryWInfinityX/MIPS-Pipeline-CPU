`timescale 1ns / 1ps

module ALU(
     input [31:0] a, 
     input [31:0] b, 
     input [3:0] aluc,   
     output reg [31:0] r,    
     output reg zero,    
     output reg carry,   
     output reg negative,    
     output reg overflow     
    );
    reg [31:0] R_ADDU, R_SUBU, R_AND, R_OR, R_XOR, R_NOR, R_LUI, R_SLTU, R_SRA, R_SLL, R_SRL;
    reg signed [31:0] R_ADD, R_SUB, R_SLT;
    reg signed [31:0] signed_a, signed_b;
        
    always @ (*)
    begin
        signed_a = a;
        signed_b = b;
        R_ADDU = a + b;
        R_ADD = signed_a + signed_b;
        R_SUBU = a - b;
        R_SUB = signed_a - signed_b;
        R_AND = a & b;
        R_OR = a | b;
        R_XOR = a ^ b;
        R_NOR = ~(a | b);
        R_LUI = {b[15:0], 16'h0000};
        R_SLT = (signed_a < signed_b) ? 1 : 0;
        R_SLTU = (a < b) ? 1 : 0;
        R_SRA = signed_b >>> a;
        R_SRL = b >> a;
        R_SLL = b << a;
    end
        
    always @ (*)
        case ({aluc[3], aluc[2], aluc[1], aluc[0]})
            4'b0000:begin
                    r = R_ADDU;
                    zero = (r == 0) ? 1 : 0;
                    carry = (r < a || r < b) ? 1 : 0;
                    //negative = 0;
                    //overflow = 0;
                    end
            4'b0010:begin
                    r = R_ADD;
                    zero = (r == 0) ? 1 : 0;
                    //carry = 0;
                    negative = (r[31] == 1) ? 1 : 0;
                    overflow = (a[31] == 0 && b[31] == 0 && r[31] == 1) || (a[31] == 1 && b[31] == 1 && r[31] == 0) ? 1 : 0;
                    end
            4'b0001:begin
                    r = R_SUBU;
                    zero = (r == 0) ? 1 : 0;
                    carry = (a < b) ? 1 : 0;
                    //negative = 0;
                    //overflow = 0;
                    end
            4'b0011:begin
                    r = R_SUB;
                    zero = (r == 0) ? 1 : 0;
                    //carry = 0;
                    negative = (r[31] == 1) ? 1 : 0;
                    overflow = (a[31] ==0 && b[31] == 0 && r[31] == 1) || (a[31] == 1 && b[31] == 1 && r[31] == 0) ? 1 : 0;
                    end
            4'b0100:begin
                    r = R_AND;
                    zero = (r == 0) ? 1 : 0;
                    //carry = 0;
                    negative = (r[31] == 1) ? 1 : 0;
                    //overflow = 0;
                    end
            4'b0101:begin
                    r = R_OR;
                    zero = (r == 0) ? 1 : 0;
                    //carry = 0;
                    negative = (r[31] == 1) ? 1 : 0;
                    //overflow = 0;
                    end
            4'b0110:begin
                    r = R_XOR;
                    zero = (r == 0) ? 1 : 0;
                    //carry = 0;
                    negative = (r[31] == 1) ? 1 : 0;
                    //overflow = 0;
                    end
            4'b0111:begin
                    r = R_NOR;
                    zero = (r == 0) ? 1 : 0;
                    //carry = 0;
                    negative = (r[31] == 1) ? 1 : 0;
                    //overflow = 0;
                    end
            4'b1000:begin
                    r = R_LUI;
                    zero = (r == 0) ? 1 : 0;
                    //carry = 0;
                    negative = (r[31] == 1) ? 1 : 0;
                    //overflow = 0;
                    end
            4'b1001:begin
                    r = R_LUI;
                    zero = (r == 0) ? 1 : 0;
                    //carry = 0;
                    negative = (r[31] == 1) ? 1 : 0;
                    //overflow = 0;
                    end
            4'b1010:begin
                    r = R_SLTU;
                    zero = (r == 0) ? 1 : 0;
                    carry = (a < b) ? 1 : 0;
                    //negative = 0;
                    //overflow = 0;
                    end
            4'b1011:begin
                    r = R_SLT;
                    zero = (r == 0) ? 1 : 0;
                    //carry = 0;
                    negative = (signed_a < signed_b) ? 1 : 0;
                    //overflow = 0;
                    end
            4'b1100:begin
                    r = R_SRA;
                    zero = (r == 0) ? 1 : 0;
                    if(a == 0)
                        carry = 0;
                    else if(a > 6'b100000)
                        carry = b[31];
                    else             
                        carry = b[a-1];
                    negative = (r[31] == 1) ? 1 : 0;
                    //overflow = 0;
                    end
            4'b1101:begin
                    r = R_SRL;
                    zero =(r == 0) ? 1 : 0;
                    if(a == 0)
                        carry = 0;
                    else if(a > 6'b100000)
                        carry = 0;
                    else            
                        carry = b[a-1];
                    negative = (r[31] == 1) ? 1 : 0;
                    //overflow = 0;
                    end
            4'b1110:begin
                    r = R_SLL;
                    zero = (r == 0) ? 1 : 0;
                    if(a == 0)
                        carry = 0;
                    else if(a > 6'b100000)
                        carry = 0;
                    else            
                        carry = b[32-a];
                    negative = (r[31] == 1) ? 1 : 0;
                    //overflow = 0;
                    end
            4'b1111:begin
                    r = R_SLL;
                    zero = (r == 0) ? 1 : 0;
                    if(a == 0)
                        carry = 0;
                    else if(a > 6'b100000)
                        carry = 0;
                    else            
                        carry = b[32-a];
                    negative = (r[31] == 1) ? 1 : 0;
                    //overflow = 0;
                    end
        endcase
        
endmodule
