`timescale 1ns / 1ps

// IF 级部件部件
// IMEM、Adder、MUX
// 输入 PC 的各类来源，以及 PC 多路选择器的控制信号
// 输出下一个 PC 和当前 PC 对应的指令以及 PC + 4
module PipeIF(
    input [31:0] pc_i,
    input [31:0] branch_addr_i,
    input [31:0] jump_addr_i,
    input [31:0] rs_addr_i,
    input [31:0] cp0_addr_i,
    input [2:0] pc_select_i,
    input pc_stall,
    output [31:0] npc_o, // next pc 
    output [31:0] pc4_o,
    output [31:0] instruction_o
);

    wire [31:0] pc4;
    wire [31:0] instruction;

    assign pc4_o = pc4;
    assign instruction_o = pc_stall? 32'h0: instruction;

    Adder pc_plus4(
        .a(pc_i),
        .b(32'h4),
        .r(pc4)
    );

    MUX6_1 mux_pc(
        .a(pc4),
        .b(branch_addr_i),
        .c(jump_addr_i),
        .d(rs_addr_i),
        .e(cp0_addr_i),
        .f(32'h4),
        .select(pc_select_i),
        .r(npc_o)
    );

    // IMEM 取指
    IMEM_ip imem(
        .addr(pc_i[12:2]),
        .instr(instruction)
    );

endmodule