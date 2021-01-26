`timescale 1ns / 1ps

// IF / ID 级间的流水寄存器
module PipeIR(
    input clk,
    input rst,
    input [31:0] Fpc4,
    input [31:0] Finstruction,
    input pc_ena_i,
    output [31:0] Dpc4,
    output [31:0] Dinstruction
);

    Reg pc(
        .clk(clk),
        .rst(rst),
        .ena(pc_ena_i),
        .data_in(Fpc4),
        .data_out(Dpc4)
    );

    Reg instruction(
        .clk(clk),
        .rst(rst),
        .ena(pc_ena_i),
        .data_in(Finstruction),
        .data_out(Dinstruction)
    );

endmodule