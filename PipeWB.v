`timescale 1ns / 1ps

// WB 级部件
// MUX
// 输入各类计算结果和控制信号
// 输出写回 ID 级的写信号、写地址和写数据
module PipeWB(
    input [31:0] alu_i,
    input [63:0] product_i,
    input [31:0] quotient_i,
    input [31:0] remainder_i,
    input [31:0] count_zeros_i,
    input [31:0] hi_i,
    input [31:0] lo_i,
    input [31:0] rs_i,
    input [31:0] dmem_rdata_i,
    input [31:0] cp0_rdata_i,
    input [31:0] link_addr_i,
    input [4:0] rf_waddr_i,
    input rf_wena_i,
    input hi_wena_i,
    input lo_wena_i,
    input [1:0] hi_select_i,
    input [1:0] lo_select_i,
    input [2:0] rd_select_i,
    output rf_wena_o,
    output hi_wena_o,
    output lo_wena_o,
    output [31:0] rf_wdata_o,
    output [31:0] hi_wdata_o,
    output [31:0] lo_wdata_o,
    output [4:0] rf_waddr_o
);

    assign rf_wena_o = rf_wena_i;
    assign hi_wena_o = hi_wena_i;
    assign lo_wena_o = lo_wena_i;
    assign rf_waddr_o = rf_waddr_i;

    MUX4_1 mux_hi(
        .a(32'b0),
        .b(rs_i),
        .c(product_i[63:32]),
        .d(remainder_i),
        .select(hi_select_i),
        .r(hi_wdata_o)
    );

    MUX4_1 mux_lo(
        .a(32'b0),
        .b(rs_i),
        .c(product_i[31:0]),
        .d(quotient_i),
        .select(lo_select_i),
        .r(lo_wdata_o)
    );

    MUX8_1 mux_rd(
        .a(32'h0),
        .b(alu_i),
        .c(count_zeros_i),
        .d(hi_i),
        .e(lo_i),
        .f(dmem_rdata_i),
        .g(cp0_rdata_i),
        //.h(link_addr_i),
        .h(product_i[31:0]),
        .select(rd_select_i),
        .r(rf_wdata_o)
    );

endmodule