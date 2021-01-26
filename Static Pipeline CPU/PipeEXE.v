`timescale 1ns / 1ps

// EXE级部件
// ALU、乘法器、除法器、CLZ、MUX
// 输入 ID 级的控制信号和各类源操作数值
// 输出向 MEM 级传递的控制信号和计算的结果
module PipeEXE(
    input [31:0] rs_i,
    input [31:0] rt_i,
    input [31:0] imm16_ext_i,
    input [3:0] aluc_i,
    input [31:0] cp0_rdata_i,
    input [31:0] link_addr_i,
    input [31:0] hi_i,
    input [31:0] lo_i,
    input [4:0] rf_waddr_i,
    input rf_wena_i,
    input hi_wena_i,
    input lo_wena_i,
    input dmem_wena_i,
    input dmem_rena_i,
    input sign_i,
    input load_sign_i,
    input a_select_i,
    input b_select_i,
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
    output [31:0] rt_o,
    output [31:0] cp0_rdata_o,
    output [31:0] link_addr_o,
    output [31:0] dmem_addr_o,
    output [4:0] rf_waddr_o,
    output rf_wena_o,
    output hi_wena_o,
    output lo_wena_o,
    output dmem_wena_o,
    output dmem_rena_o,
    output load_sign_o,
    output [2:0] load_select_o,
    output [2:0] store_select_o,
    output [1:0] hi_select_o,
    output [1:0] lo_select_o,
    output [2:0] rd_select_o
);

    wire [31:0] a, b;
    wire [31:0] alu;
    wire zero, carry, negative, overflow;

    assign hi_o = hi_i;
    assign lo_o = lo_i;
    assign rs_o = rs_i;
    assign rt_o = rt_i;
    assign cp0_rdata_o = cp0_rdata_i;
    assign link_addr_o = link_addr_i;
    assign rf_waddr_o = rf_waddr_i;
    assign rf_wena_o = rf_wena_i;
    assign hi_wena_o = hi_wena_i;
    assign lo_wena_o = lo_wena_i;
    assign dmem_wena_o = dmem_wena_i;
    assign dmem_rena_o = dmem_rena_i;
    assign load_sign_o = load_sign_i;
    assign load_select_o = load_select_i;
    assign store_select_o = store_select_i;
    assign hi_select_o = hi_select_i;
    assign lo_select_o = lo_select_i;
    assign rd_select_o = rd_select_i;
    assign alu_o = alu;
    assign dmem_addr_o = alu;

    MUX2_1 mux_a(
        .a(rs_i),
        .b({27'b0, imm16_ext_i[10:6]}),
        .select(a_select_i),
        .r(a)
    );

    MUX2_1 mux_b(
        .a(rt_i),
        .b(imm16_ext_i),
        .select(b_select_i),
        .r(b)
    );

    ALU alu_unit(
        .a(a),
        .b(b),
        .aluc(aluc_i),
        .r(alu),
        .zero(zero),
        .carry(carry),
        .negative(negative),
        .overflow(overflow)
    );

    MULT mult(
        .a(a),
        .b(b),
        .sign(sign_i),
        .z(product_o)
    );

    DIV div(
        .dividend(a),
        .divisor(b),
        .sign(sign_i),
        .q(quotient_o),
        .r(remainder_o)
    );

    Counter counter(
        .data_in(rs_i),
        .data_out(count_zeros_o)
    );

endmodule