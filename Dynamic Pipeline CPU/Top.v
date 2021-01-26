`timescale 1ns / 1ps

module Top(
    input clk,
    input rst,
    output [7:0] o_seg,// 显示数字
	output [7:0] o_sel // 选择数码管
);

    wire clk_in;
    wire [31:0] pc;
    wire [31:0] instr;
    wire [31:0] data_out;

    Divider divider(
        .I_CLK(clk),
        .rst(rst),
        .O_CLK(clk_in)
    );

    PipeCPU pipecpu(
        .clk(clk_in),
        .rst(rst),
        .pc_o(pc),
        .instruction_o(instr),
        .data_out(data_out)
    );

    Seg7x16 seg7x16(
        .clk(clk),
        .rst(rst),
        .cs(1'b1),
        .i_data(data_out),
        .o_seg(o_seg),
        .o_sel(o_sel)
    );

endmodule
