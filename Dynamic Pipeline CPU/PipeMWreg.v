`timescale 1ns / 1ps

// MEM / WB 级间的流水寄存器用来存放控制信号和各类待写入的结果数据
module PipeMWreg(
    input clk,
    input rst,
    input [31:0] Malu,
    input [63:0] Mproduct,
    input [31:0] Mquotient,
    input [31:0] Mremainder,
    input [31:0] Mcount_zeros,
    input [31:0] Mhi,
    input [31:0] Mlo,
    input [31:0] Mrs,
    input [31:0] Mdmem_rdata,
    input [31:0] Mcp0_rdata,
    input [31:0] Mlink_addr,
    input [4:0] Mrf_waddr,
    input Mrf_wena,
    input Mhi_wena,
    input Mlo_wena,
    input [1:0] Mhi_select,
    input [1:0] Mlo_select,
    input [2:0] Mrd_select,
    output reg [31:0] Walu,
    output reg [63:0] Wproduct,
    output reg [31:0] Wquotient,
    output reg [31:0] Wremainder,
    output reg [31:0] Wcount_zeros,
    output reg [31:0] Whi,
    output reg [31:0] Wlo,
    output reg [31:0] Wrs,
    output reg [31:0] Wdmem_rdata,
    output reg [31:0] Wcp0_rdata,
    output reg [31:0] Wlink_addr,
    output reg [4:0] Wrf_waddr,
    output reg Wrf_wena,
    output reg Whi_wena,
    output reg Wlo_wena,
    output reg [1:0] Whi_select,
    output reg [1:0] Wlo_select,
    output reg [2:0] Wrd_select
);

    always @ (posedge clk or posedge rst)
    begin
        if (rst == 1)
        begin
            Walu <= 0;
            Wproduct <= 0;
            Wquotient <= 0;
            Wremainder <= 0;
            Wcount_zeros <= 0;
            Whi <= 0;
            Wlo <= 0;
            Wrs <= 0;
            Wdmem_rdata <= 0;
            Wcp0_rdata <= 0;
            Wlink_addr <= 0;
            Wrf_waddr <= 0;
            Wrf_wena <= 0;
            Whi_wena <= 0;
            Wlo_wena <= 0;
            Whi_select <= 0;
            Wlo_select <= 0;
            Wrd_select <= 0;
        end
        else
        begin
            Walu <= Malu;
            Wproduct <= Mproduct;
            Wquotient <= Mquotient;
            Wremainder <= Mremainder;
            Wcount_zeros <= Mcount_zeros;
            Whi <= Mhi;
            Wlo <= Mlo;
            Wrs <= Mrs;
            Wdmem_rdata <= Mdmem_rdata;
            Wcp0_rdata <= Mcp0_rdata;
            Wlink_addr <= Mlink_addr;
            Wrf_waddr <= Mrf_waddr;
            Wrf_wena <= Mrf_wena;
            Whi_wena <= Mhi_wena;
            Wlo_wena <= Mlo_wena;
            Whi_select <= Mhi_select;
            Wlo_select <= Mlo_select;
            Wrd_select <= Mrd_select;
        end
    end

endmodule