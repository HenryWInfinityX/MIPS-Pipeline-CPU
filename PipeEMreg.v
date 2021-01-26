`timescale 1ns / 1ps

// EXE / MEM 级间的流水寄存器用来存放 EXE 级产生的计算结果和传递的各类控制信号
module PipeEMreg(
    input clk,
    input rst,
    input [31:0] Ealu,
    input [63:0] Eproduct,
    input [31:0] Equotient,
    input [31:0] Eremainder,
    input [31:0] Ecount_zeros,
    input [31:0] Ehi,
    input [31:0] Elo,
    input [31:0] Ers,
    input [31:0] Ert,
    input [31:0] Ecp0_rdata,
    input [31:0] Elink_addr,
    input [31:0] Edmem_addr,
    input [4:0] Erf_waddr,
    input Erf_wena,
    input Ehi_wena,
    input Elo_wena,
    input Edmem_wena,
    input Edmem_rena,
    input Eload_sign,
    input [2:0] Eload_select,
    input [2:0] Estore_select,
    input [1:0] Ehi_select,
    input [1:0] Elo_select,
    input [2:0] Erd_select,
    output reg [31:0] Malu,
    output reg [63:0] Mproduct,
    output reg [31:0] Mquotient,
    output reg [31:0] Mremainder,
    output reg [31:0] Mcount_zeros,
    output reg [31:0] Mhi,
    output reg [31:0] Mlo,
    output reg [31:0] Mrs,
    output reg [31:0] Mrt,
    output reg [31:0] Mcp0_rdata,
    output reg [31:0] Mlink_addr,
    output reg [31:0] Mdmem_addr,
    output reg [4:0] Mrf_waddr,
    output reg Mrf_wena,
    output reg Mhi_wena,
    output reg Mlo_wena,
    output reg Mdmem_wena,
    output reg Mdmem_rena,
    output reg Mload_sign,
    output reg [2:0] Mload_select,
    output reg [2:0] Mstore_select,
    output reg [1:0] Mhi_select,
    output reg [1:0] Mlo_select,
    output reg [2:0] Mrd_select
);

    always @ (posedge clk or posedge rst)
    begin
        if (rst == 1)
        begin
            Malu <= 0;
            Mproduct <= 0;
            Mquotient <= 0;
            Mremainder <= 0;
            Mcount_zeros <= 0;
            Mhi <= 0;
            Mlo <= 0;
            Mrs <= 0;
            Mrt <= 0;
            Mcp0_rdata <= 0;
            Mlink_addr <= 0;
            Mdmem_addr <= 0;
            Mrf_waddr <= 0;
            Mrf_wena <= 0;
            Mhi_wena <= 0;
            Mlo_wena <= 0;
            Mdmem_wena <= 0;
            Mdmem_rena <= 0;
            Mload_sign <= 0;
            Mload_select <= 0;
            Mstore_select <= 0;
            Mhi_select <= 0;
            Mlo_select <= 0;
            Mrd_select <= 0;
        end
        else
        begin
            Malu <= Ealu;
            Mproduct <= Eproduct;
            Mquotient <= Equotient;
            Mremainder <= Eremainder;
            Mcount_zeros <= Ecount_zeros;
            Mhi <= Ehi;
            Mlo <= Elo;
            Mrs <= Ers;
            Mrt <= Ert;
            Mcp0_rdata <= Ecp0_rdata;
            Mlink_addr <= Elink_addr;
            Mdmem_addr <= Edmem_addr;
            Mrf_waddr <= Erf_waddr;
            Mrf_wena <= Erf_wena;
            Mhi_wena <= Ehi_wena;
            Mlo_wena <= Elo_wena;
            Mdmem_wena <= Edmem_wena;
            Mdmem_rena <= Edmem_rena;
            Mload_sign <= Eload_sign;
            Mload_select <= Eload_select;
            Mstore_select <= Estore_select;
            Mhi_select <= Ehi_select;
            Mlo_select <= Elo_select;
            Mrd_select <= Erd_select;
        end
    end

endmodule