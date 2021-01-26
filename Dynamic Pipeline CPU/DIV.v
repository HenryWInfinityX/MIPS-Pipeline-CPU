`timescale 1ns / 1ps

module DIV(
    input [31:0] dividend, //被除数
    input [31:0] divisor, //除数
    input sign,
    output [31:0] q, //商
    output [31:0] r //余数
);
    
    wire signed [32:0] temp_a;
    wire signed [32:0] temp_b;
    wire signed [32:0] temp_q;
    wire signed [32:0] temp_r;

    assign temp_a = {dividend[31], dividend};
    assign temp_b = {divisor[31], divisor};
    assign temp_q = temp_a / temp_b;
    assign temp_r = temp_a % temp_b;

    assign q = (sign == 1)? temp_q[31:0]: (dividend / divisor);
    assign r = (sign == 1)? temp_r[31:0]: (dividend % divisor);
    
endmodule