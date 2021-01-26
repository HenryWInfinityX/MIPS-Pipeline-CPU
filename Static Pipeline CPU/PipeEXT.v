`timescale 1ns / 1ps

module EXT5(
    input  [4:0]  a,
    output [31:0] b
);
    assign b = {27'b0, a};
endmodule

module EXT16(
    input [15:0] a,
    input sign,          
    output [31:0] b
);
    //sign: 1: sign_extend; 0: zero_extend;
    assign b = sign ? {{(16){a[15]}},a} : {16'b0,a};
endmodule

// 有符号扩展，18 位 - 32 位
module EXT18(
    input  [15:0] a,
    output [31:0] b
);
    assign b = {{(14){a[15]}}, a, 2'b00};
endmodule