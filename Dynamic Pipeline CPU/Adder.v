`timescale 1ns / 1ps

module Adder(
    input [31:0] a,
    input [31:0] b,
    //output overflow,
    output [31:0] r
    );

    assign r = a + b;
    //assign overflow = ((a[31] == b[31]) && (a[31] != r[31]))? 1: 0;
    
endmodule
