`timescale 1ns / 1ps

module MULT(
    input  [31:0] a, // 输入数a（被乘数）
    input  [31:0] b, // 输入数b（乘数）
    input sign,
    output [63:0] z // 乘积输出z
);

    wire signed [32:0] temp_a;
    wire signed [32:0] temp_b;
    wire signed [65:0] temp_z;

    assign temp_a = {a[31], a};
    assign temp_b = {b[31], b};
    assign temp_z = temp_a * temp_b;

    assign z = (sign == 1)? temp_z[63:0]: (a * b);

endmodule