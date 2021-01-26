`timescale 1ns / 1ps

// 32 路 2 选 1 多路选择器
// 用于：PipeEXE
module MUX2_1(
    input [31:0] a,
    input [31:0] b,
    input select,
    output [31:0] r
);

    assign r = (select == 1'b0)? a: b;

endmodule

// 32 路 4 选 1 多路选择器
// 用于：PipeWB
module MUX4_1(
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    input [1:0] select,
    output [31:0] r
);

    assign r = (select == 2'b00)? a:
               (select == 2'b01)? b:
               (select == 2'b10)? c:
               (select == 2'b11)? d: 0;

endmodule

// 32 路 6 选 1 多路选择器
// 用于：PipeIF
module MUX6_1(
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    input [31:0] e,
    input [31:0] f,
    input [2:0] select,
    output [31:0] r
);

    assign r = (select == 3'b000)? a:
               (select == 3'b001)? b:
               (select == 3'b010)? c:
               (select == 3'b011)? d:
               (select == 3'b100)? e:
               (select == 3'b101)? f: 0;

endmodule

// 32 路 8 选 1 多路选择器
// 用于：PipeWB
module MUX8_1(
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    input [31:0] e,
    input [31:0] f,
    input [31:0] g,
    input [31:0] h,
    input [2:0] select,
    output [31:0] r
);

    assign r = (select == 3'b000)? a:
               (select == 3'b001)? b:
               (select == 3'b010)? c:
               (select == 3'b011)? d:
               (select == 3'b100)? e:
               (select == 3'b101)? f:
               (select == 3'b110)? g:
               (select == 3'b111)? h: 0;

endmodule