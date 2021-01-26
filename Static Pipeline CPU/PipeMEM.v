`timescale 1ns / 1ps

// MEM 级部件
// DMEM、选择数据长度的模块、MUX
// 输入 EXE 级的计算结果和传递的控制信号
// 输出传递的控制信号与读出的结果
module PipeMEM(
    input clk,
    input [31:0] alu_i,
    input [63:0] product_i,
    input [31:0] quotient_i,
    input [31:0] remainder_i,
    input [31:0] count_zeros_i,
    input [31:0] hi_i,
    input [31:0] lo_i,
    input [31:0] rs_i,
    input [31:0] rt_i,
    input [31:0] cp0_rdata_i,
    input [31:0] link_addr_i,
    input [4:0] rf_waddr_i,
    input [31:0] dmem_addr_i,
    input rf_wena_i,
    input hi_wena_i,
    input lo_wena_i,
    input dmem_wena_i,
    input dmem_rena_i,
    input load_sign_i,
    input [2:0] load_select_i,
    input [2:0] store_select_i,
    input [1:0] hi_select_i,
    input [1:0] lo_select_i,
    input [2:0] rd_select_i,
    output [31:0] alu_o,
    output [63:0] product_o,
    output [31:0] quotient_o,
    output [31:0] remainder_o,
    output [31:0] count_zeros_o,
    output [31:0] hi_o,
    output [31:0] lo_o,
    output [31:0] rs_o,
    output [31:0] dmem_rdata_o,
    output [31:0] cp0_rdata_o,
    output [31:0] link_addr_o,
    output [4:0] rf_waddr_o,
    output rf_wena_o,
    output hi_wena_o,
    output lo_wena_o,
    output [1:0] hi_select_o,
    output [1:0] lo_select_o,
    output [2:0] rd_select_o
);
    
    wire [31:0] dmem_out;

    assign alu_o = alu_i;
    assign product_o = product_i;
    assign quotient_o = quotient_i;
    assign remainder_o = remainder_i;
    assign count_zeros_o = count_zeros_i;
    assign hi_o = hi_i;
    assign lo_o = lo_i;
    assign rs_o = rs_i;
    assign rf_wena_o = rf_wena_i;
    assign hi_wena_o = hi_wena_i;
    assign lo_wena_o = lo_wena_i;
    assign cp0_rdata_o = cp0_rdata_i;
    assign link_addr_o = link_addr_i;
    assign rf_waddr_o = rf_waddr_i;
    assign hi_select_o = hi_select_i;
    assign lo_select_o = lo_select_i;
    assign rd_select_o = rd_select_i;

    DMEM dmem(
        .clk(clk),
        .rena(dmem_rena_i),
        .wena(dmem_wena_i),
        .store_select(store_select_i),
        .addr(dmem_addr_i),
        .data_in(rt_i),
        .data_out(dmem_out)
    );

    Cutter cutter(
        .data_in(dmem_out),
        .select(load_select_i),
        .sign(load_sign_i),
        .data_out(dmem_rdata_o)
    );

endmodule