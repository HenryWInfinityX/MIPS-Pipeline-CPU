`timescale 1ns / 1ps

// ID / EXE 级间的流水寄存器，传递ID级输出的控制信号和读出的数据
module PipeDEreg(
    input clk,
	input rst,
    input [31:0] Drs,
    input [31:0] Drt,
    input [31:0] Dimm16_ext,
    input [3:0] Daluc,
    input [31:0] Dcp0_rdata,
    input [31:0] Dlink_addr,
    input [31:0] Dhi,
    input [31:0] Dlo,
    input [4:0] Drf_waddr,
    input Drf_wena,
    input Dhi_wena,
    input Dlo_wena,
    input Ddmem_wena,
    input Ddmem_rena,
    input Dsign,
    input Dload_sign,
    input Da_select,
    input Db_select,
    input [2:0] Dload_select,
    input [2:0] Dstore_select,
    input [1:0] Dhi_select,
    input [1:0] Dlo_select,
    input [2:0] Drd_select,
    // new
    input [53:0] Dcode, 
    output reg [31:0] Ers,
    output reg [31:0] Ert,
    output reg [31:0] Eimm16_ext,
    output reg [3:0] Ealuc,
    output reg [31:0] Ecp0_rdata,
    output reg [31:0] Elink_addr,
    output reg [31:0] Ehi,
    output reg [31:0] Elo,
    output reg [4:0] Erf_waddr,
    output reg Erf_wena,
    output reg Ehi_wena,
    output reg Elo_wena,
    output reg Edmem_wena,
    output reg Edmem_rena,
    output reg Esign,
    output reg Eload_sign,
    output reg Ea_select,
    output reg Eb_select,
    output reg [2:0] Eload_select,
    output reg [2:0] Estore_select,
    output reg [1:0] Ehi_select,
    output reg [1:0] Elo_select,
    output reg [2:0] Erd_select,
    // new
    output reg [53:0] Ecode
);

    always @ (posedge clk or posedge rst)
    begin
        if (rst == 1)
        begin
            Ers <= 0;
            Ert <= 0;
            Eimm16_ext <= 0;
            Ealuc <= 0;
            Ecp0_rdata <= 0;
            Elink_addr <= 0;
            Ehi <= 0;
            Elo <= 0;
            Erf_waddr <= 0;
            Erf_wena <= 0;
            Ehi_wena <= 0;
            Elo_wena <= 0;
            Edmem_wena <= 0;
            Edmem_rena <= 0;
            Esign <= 0;
            Eload_sign <= 0;
            Ea_select <= 0;
            Eb_select <= 0;
            Eload_select <= 0;
            Estore_select <= 0;
            Ehi_select <= 0;
            Elo_select <= 0;
            Erd_select <= 0;
        end
        else
        begin
            Ers <= Drs;
            Ert <= Drt;
            Eimm16_ext <= Dimm16_ext;
            Ealuc <= Daluc;
            Ecp0_rdata <= Dcp0_rdata;
            Elink_addr <= Dlink_addr;
            Ehi <= Dhi;
            Elo <= Dlo;
            Erf_waddr <= Drf_waddr;
            Erf_wena <= Drf_wena;
            Ehi_wena <= Dhi_wena;
            Elo_wena <= Dlo_wena;
            Edmem_wena <= Ddmem_wena;
            Edmem_rena <= Ddmem_rena;
            Eload_sign <= Dload_sign;
            Ea_select <= Da_select;
            Eb_select <= Db_select;
            Esign <= Dsign;
            Eload_select <= Dload_select;
            Estore_select <= Dstore_select;
            Ehi_select <= Dhi_select;
            Elo_select <= Dlo_select;
            Erd_select <= Drd_select;
        end
    end

endmodule