`timescale 1ns / 1ps

module PipeCPU(
    input clk,
    input rst,
    output [31:0] pc_o,
    output [31:0] instruction_o,
    output [31:0] data_out
);
    wire pc_ena;
    // IF
    // in
    wire [31:0] pc;
    wire [31:0] branch_addr, jump_addr, rs_addr, cp0_addr;
    wire [2:0] pc_select;
    wire pc_stall;
    // out
    wire [31:0] npc;
    wire [31:0] FDpc4;
    wire [31:0] FDinstruction;
    
    // ID
    // in
    wire [31:0] Dpc4;
    wire [31:0] Dinstruction;
    wire Drf_wena;
    wire Dhi_wena, Dlo_wena;
    wire [31:0] Drf_wdata;
    wire [31:0] Dhi_wdata, Dlo_wdata;
    wire [4:0] Drf_waddr;
    // out
    wire stall;
    wire [31:0] reg28;
    wire [31:0] DEimm16_ext;
    wire [3:0] DEaluc;
    wire [31:0] DEhi, DElo;
    wire [31:0] DErs, DErt;
    wire [31:0] DEcp0_rdata;
    wire [31:0] DElink_addr;
    wire [4:0] DErf_waddr;
    wire DErf_wena;
    wire DEhi_wena, DElo_wena;
    wire DEdmem_wena, DEdmem_rena;
    wire DEsign;
    wire DEload_sign;
    wire DEa_select, DEb_select;
    wire [2:0] DEload_select, DEstore_select;
    wire [1:0] DEhi_select, DElo_select;
    wire [2:0] DErd_select;
    // new
    wire [53:0] DEcode;

    // EXE
    // in
    wire [31:0] Eimm16_ext;
    wire [3:0] Ealuc;
    wire [31:0] Ehi, Elo;
    wire [31:0] Ers, Ert;
    wire [31:0] Ecp0_rdata;
    wire [31:0] Elink_addr;
    wire [4:0] Erf_waddr;
    wire Erf_wena;
    wire Ehi_wena, Elo_wena;
    wire Edmem_wena, Edmem_rena;
    wire Esign;
    wire Eload_sign;
    wire Ea_select, Eb_select;
    wire [2:0] Eload_select, Estore_select;
    wire [1:0] Ehi_select, Elo_select;
    wire [2:0] Erd_select;
    // new
    wire [53:0] Ecode;
    // out
    wire [31:0] EMalu;
    wire [63:0] EMproduct;
    wire [31:0] EMquotient, EMremainder;
    wire [31:0] EMcount_zeros;
    wire [31:0] EMhi, EMlo;
    wire [31:0] EMrs, EMrt;
    wire [31:0] EMcp0_rdata;
    wire [31:0] EMlink_addr;
    wire [4:0] EMrf_waddr;
    wire [31:0] EMdmem_addr;
    wire EMrf_wena;
    wire EMhi_wena, EMlo_wena;
    wire EMdmem_wena, EMdmem_rena;
    wire EMload_sign;
    wire [2:0] EMload_select, EMstore_select;
    wire [1:0] EMhi_select, EMlo_select;
    wire [2:0] EMrd_select;

    // MEM
    // in
    wire [31:0] Malu;
    wire [63:0] Mproduct;
    wire [31:0] Mquotient, Mremainder;
    wire [31:0] Mcount_zeros;
    wire [31:0] Mhi, Mlo;
    wire [31:0] Mrs, Mrt;
    wire [31:0] Mcp0_rdata;
    wire [31:0] Mlink_addr;
    wire [4:0] Mrf_waddr;
    wire [31:0] Mdmem_addr;
    wire Mrf_wena;
    wire Mhi_wena, Mlo_wena;
    wire Mdmem_wena, Mdmem_rena;
    wire Mload_sign;
    wire [2:0] Mload_select, Mstore_select;
    wire [1:0] Mhi_select, Mlo_select;
    wire [2:0] Mrd_select;
    // out
    wire [31:0] MWalu;
    wire [63:0] MWproduct;
    wire [31:0] MWquotient, MWremainder;
    wire [31:0] MWcount_zeros;
    wire [31:0] MWhi, MWlo;
    wire [31:0] MWrs;
    wire [31:0] MWdmem_rdata;
    wire [31:0] MWcp0_rdata;
    wire [31:0] MWlink_addr;
    wire [4:0] MWrf_waddr;
    wire MWrf_wena;
    wire MWhi_wena, MWlo_wena;
    wire [1:0] MWhi_select, MWlo_select;
    wire [2:0] MWrd_select;

    // WB
    // in
    wire [31:0] Walu;
    wire [63:0] Wproduct;
    wire [31:0] Wquotient, Wremainder;
    wire [31:0] Wcount_zeros;
    wire [31:0] Whi, Wlo;
    wire [31:0] Wrs;
    wire [31:0] Wdmem_rdata;
    wire [31:0] Wcp0_rdata;
    wire [31:0] Wlink_addr;
    wire [4:0] Wrf_waddr;
    wire Wrf_wena;
    wire Whi_wena, Wlo_wena;
    wire [1:0] Whi_select, Wlo_select;
    wire [2:0] Wrd_select;

    assign pc_ena = (stall == 0);
    assign pc_stall = (pc_select != 3'b000); // 不是 pc + 4 的情况
    assign pc_o = (pc_stall)? 32'h0: pc;
    assign instruction_o = FDinstruction;
    assign data_out = reg28;

    // PC
    PCReg pcreg(
        .clk(~clk), // negedge
        .rst(rst),
        .ena(pc_ena),
        .data_in(npc),
        .data_out(pc)
    );

    // IF: instruction fetch
    PipeIF IF(
        .pc_i(pc),
        .branch_addr_i(branch_addr),
        .jump_addr_i(jump_addr),
        .rs_addr_i(rs_addr),
        .cp0_addr_i(cp0_addr),
        .pc_select_i(pc_select),
        .pc_stall(pc_stall),
        .npc_o(npc),
        .pc4_o(FDpc4),
        .instruction_o(FDinstruction)
    );

    // IF ID REG
    PipeIR IR(
        .clk(~clk), // posedge
        .rst(rst),
        .Fpc4(FDpc4),
        .Finstruction(FDinstruction),
        .pc_ena_i(pc_ena),
        .Dpc4(Dpc4),
        .Dinstruction(Dinstruction)
    );

    // ID: instruction decode
    PipeID ID(
        .clk(clk), // posedge
        .rst(rst),
        .pc4_i(Dpc4),
        .instruction_i(Dinstruction),
        .rf_wdata_i(Drf_wdata),
        .rf_waddr_i(Drf_waddr),
        .rf_wena_i(Drf_wena),
        .hi_wdata_i(Dhi_wdata),
        .lo_wdata_i(Dlo_wdata),
        // new / clock problem?
        .Ealu_i(EMalu),
        .Ecount_zeros_i(EMcount_zeros),
        .Eproduct_i(EMproduct),
        .Equotient_i(Equotient),
        .Eremainder_i(EMremainder),
        .Elink_addr_i(EMlink_addr),
        .Ecp0_rdata_i(EMcp0_rdata),
        .Ers_i(EMrs),
        .Ehi_i(EMhi),
        .Elo_i(EMlo),
        .Ehi_select_i(EMhi_select),
        .Elo_select_i(EMlo_select),
        .Erd_select_i(EMrd_select),
        .Erf_waddr_i(EMrf_waddr),
        .Erf_wena_i(EMrf_wena),
        .Ehi_wena_i(EMhi_wena),
        .Elo_wena_i(EMlo_wena),
        .Ecode_i(Ecode), // clock?
        .Malu_i(MWalu),
        .Mcount_zeros_i(MWcount_zeros),
        .Mproduct_i(MWproduct),
        .Mquotient_i(MWquotient),
        .Mremainder_i(MWremainder),
        .Mlink_addr_i(MWlink_addr),
        .Mcp0_rdata_i(MWcp0_rdata),
        .Mdmem_rdata_i(MWdmem_rdata),
        .Mrs_i(MWrs),
        .Mhi_i(MWhi),
        .Mlo_i(MWlo),
        .Mhi_select_i(MWhi_select),
        .Mlo_select_i(MWlo_select),
        .Mrd_select_i(MWrd_select),
        .Mrf_waddr_i(MWrf_waddr),
        .Mrf_wena_i(MWrf_wena),
        .Mhi_wena_i(MWhi_wena),
        .Mlo_wena_i(MWlo_wena),
        // end of new
        .branch_addr_o(branch_addr),
        .jump_addr_o(jump_addr),
        .rs_addr_o(rs_addr),
        .cp0_addr_o(cp0_addr),
        .link_addr_o(DElink_addr),
        .rs_o(DErs),
        .rt_o(DErt),
        .imm16_ext_o(DEimm16_ext),
        .aluc_o(DEaluc),
        .cp0_rdata_o(DEcp0_rdata),
        .hi_o(DEhi),
        .lo_o(DElo),
        .rf_waddr_o(DErf_waddr),
        .stall_o(stall),
        .reg28_o(reg28),
        .rf_wena_o(DErf_wena),
        .hi_wena_o(DEhi_wena),
        .lo_wena_o(DElo_wena),
        .dmem_wena_o(DEdmem_wena),
        .dmem_rena_o(DEdmem_rena),
        .sign_o(DEsign),
        .load_sign_o(DEload_sign),
        .a_select_o(DEa_select),
        .b_select_o(DEb_select),
        .pc_select_o(pc_select),
        .load_select_o(DEload_select),
        .store_select_o(DEstore_select),
        .hi_select_o(DEhi_select),
        .lo_select_o(DElo_select),
        .rd_select_o(DErd_select)
    );

    // ID EXE REG
    PipeDEreg DEReg(
        .clk(~clk), // posedge
        .rst(rst),
        .Drs(DErs),
        .Drt(DErt),
        .Dimm16_ext(DEimm16_ext),
        .Daluc(DEaluc),
        .Dcp0_rdata(DEcp0_rdata),
        .Dlink_addr(DElink_addr),
        .Dhi(DEhi),
        .Dlo(DElo),
        .Drf_waddr(DErf_waddr),
        .Drf_wena(DErf_wena),
        .Dhi_wena(DEhi_wena),
        .Dlo_wena(DElo_wena),
        .Ddmem_wena(DEdmem_wena),
        .Ddmem_rena(DEdmem_rena),
        .Dsign(DEsign),
        .Dload_sign(DEload_sign),
        .Da_select(DEa_select),
        .Db_select(DEb_select),
        .Dload_select(DEload_select),
        .Dstore_select(DEstore_select),
        .Dhi_select(DEhi_select),
        .Dlo_select(DElo_select),
        .Drd_select(DErd_select), 
        // new
        .Dcode(DEcode),
        //
        .Ers(Ers),
        .Ert(Ert),
        .Eimm16_ext(Eimm16_ext),
        .Ealuc(Ealuc),
        .Ecp0_rdata(Ecp0_rdata),
        .Elink_addr(Elink_addr),
        .Ehi(Ehi),
        .Elo(Elo),
        .Erf_waddr(Erf_waddr),
        .Erf_wena(Erf_wena),
        .Ehi_wena(Ehi_wena),
        .Elo_wena(Elo_wena),
        .Edmem_wena(Edmem_wena),
        .Edmem_rena(Edmem_rena),
        .Esign(Esign),
        .Eload_sign(Eload_sign),
        .Ea_select(Ea_select),
        .Eb_select(Eb_select),
        .Eload_select(Eload_select),
        .Estore_select(Estore_select),
        .Ehi_select(Ehi_select),
        .Elo_select(Elo_select),
        .Erd_select(Erd_select),
        // new
        .Ecode(Ecode)
        //
    );

    // EXE: execute
    PipeEXE EXE(
        .rs_i(Ers),
        .rt_i(Ert),
        .imm16_ext_i(Eimm16_ext),
        .aluc_i(Ealuc),
        .cp0_rdata_i(Ecp0_rdata),
        .link_addr_i(Elink_addr),
        .hi_i(Ehi),
        .lo_i(Elo),
        .rf_waddr_i(Erf_waddr),
        .rf_wena_i(Erf_wena),
        .hi_wena_i(Ehi_wena),
        .lo_wena_i(Elo_wena),
        .dmem_wena_i(Edmem_wena),
        .dmem_rena_i(Edmem_rena),
        .sign_i(Esign),
        .load_sign_i(Eload_sign),
        .a_select_i(Ea_select),
        .b_select_i(Eb_select),
        .load_select_i(Eload_select),
        .store_select_i(Estore_select),
        .hi_select_i(Ehi_select),
        .lo_select_i(Elo_select),
        .rd_select_i(Erd_select), 
        .alu_o(EMalu),
        .product_o(EMproduct),
        .quotient_o(EMquotient),
        .remainder_o(EMremainder),
        .count_zeros_o(EMcount_zeros),
        .hi_o(EMhi),
        .lo_o(EMlo),
        .rs_o(EMrs),
        .rt_o(EMrt),
        .cp0_rdata_o(EMcp0_rdata),
        .link_addr_o(EMlink_addr),
        .dmem_addr_o(EMdmem_addr),
        .rf_waddr_o(EMrf_waddr),
        .rf_wena_o(EMrf_wena),
        .hi_wena_o(EMhi_wena),
        .lo_wena_o(EMlo_wena),
        .dmem_wena_o(EMdmem_wena),
        .dmem_rena_o(EMdmem_rena),
        .load_sign_o(EMload_sign),
        .load_select_o(EMload_select),
        .store_select_o(EMstore_select),
        .hi_select_o(EMhi_select),
        .lo_select_o(EMlo_select),
        .rd_select_o(EMrd_select)
    );

    // EXE MEM REG
    PipeEMreg EMReg(
        .clk(~clk), // posedge
        .rst(rst),
        .Ealu(EMalu),
        .Eproduct(EMproduct),
        .Equotient(EMquotient),
        .Eremainder(EMremainder),
        .Ecount_zeros(EMcount_zeros),
        .Ehi(EMhi),
        .Elo(EMlo),
        .Ers(EMrs),
        .Ert(EMrt),
        .Ecp0_rdata(EMcp0_rdata),
        .Elink_addr(EMlink_addr),
        .Edmem_addr(EMdmem_addr),
        .Erf_waddr(EMrf_waddr),
        .Erf_wena(EMrf_wena),
        .Ehi_wena(EMhi_wena),
        .Elo_wena(EMlo_wena),
        .Edmem_wena(EMdmem_wena),
        .Edmem_rena(EMdmem_rena),
        .Eload_sign(EMload_sign),
        .Eload_select(EMload_select),
        .Estore_select(EMstore_select),
        .Ehi_select(EMhi_select),
        .Elo_select(EMlo_select),
        .Erd_select(EMrd_select),
        .Malu(Malu),
        .Mproduct(Mproduct),
        .Mquotient(Mquotient),
        .Mremainder(Mremainder),
        .Mcount_zeros(Mcount_zeros),
        .Mhi(Mhi),
        .Mlo(Mlo),
        .Mrs(Mrs),
        .Mrt(Mrt),
        .Mcp0_rdata(Mcp0_rdata),
        .Mlink_addr(Mlink_addr),
        .Mdmem_addr(Mdmem_addr),
        .Mrf_waddr(Mrf_waddr),
        .Mrf_wena(Mrf_wena),
        .Mhi_wena(Mhi_wena),
        .Mlo_wena(Mlo_wena),
        .Mdmem_wena(Mdmem_wena),
        .Mdmem_rena(Mdmem_rena),
        .Mload_sign(Mload_sign),
        .Mload_select(Mload_select),
        .Mstore_select(Mstore_select),
        .Mhi_select(Mhi_select),
        .Mlo_select(Mlo_select),
        .Mrd_select(Mrd_select)
    );

    // MEM: memory access
    PipeMEM MEM(
        .clk(~clk), // posedge
        .alu_i(Malu),
        .product_i(Mproduct),
        .quotient_i(Mquotient),
        .remainder_i(Mremainder),
        .count_zeros_i(Mcount_zeros),
        .hi_i(Mhi),
        .lo_i(Mlo),
        .rs_i(Mrs),
        .rt_i(Mrt),
        .cp0_rdata_i(Mcp0_rdata),
        .link_addr_i(Mlink_addr),
        .rf_waddr_i(Mrf_waddr),
        .dmem_addr_i(Mdmem_addr),
        .rf_wena_i(Mrf_wena),
        .hi_wena_i(Mhi_wena),
        .lo_wena_i(Mlo_wena),
        .dmem_wena_i(Mdmem_wena),
        .dmem_rena_i(Mdmem_rena),
        .load_sign_i(Mload_sign),
        .load_select_i(Mload_select),
        .store_select_i(Mstore_select),
        .hi_select_i(Mhi_select),
        .lo_select_i(Mlo_select),
        .rd_select_i(Mrd_select),
        .alu_o(MWalu),
        .product_o(MWproduct),
        .quotient_o(MWquotient),
        .remainder_o(MWremainder),
        .count_zeros_o(MWcount_zeros),
        .hi_o(MWhi),
        .lo_o(MWlo),
        .rs_o(MWrs),
        .dmem_rdata_o(MWdmem_rdata),
        .cp0_rdata_o(MWcp0_rdata),
        .link_addr_o(MWlink_addr),
        .rf_waddr_o(MWrf_waddr),
        .rf_wena_o(MWrf_wena),
        .hi_wena_o(MWhi_wena),
        .lo_wena_o(MWlo_wena),
        .hi_select_o(MWhi_select),
        .lo_select_o(MWlo_select),
        .rd_select_o(MWrd_select)
    );

    // MEM WB REG
    PipeMWreg MWReg(
        .clk(~clk), // posedge
        .rst(rst),
        .Malu(MWalu),
        .Mproduct(MWproduct),
        .Mquotient(MWquotient),
        .Mremainder(MWremainder),
        .Mcount_zeros(MWcount_zeros),
        .Mhi(MWhi),
        .Mlo(MWlo),
        .Mrs(MWrs),
        .Mdmem_rdata(MWdmem_rdata),
        .Mcp0_rdata(MWcp0_rdata),
        .Mlink_addr(MWlink_addr),
        .Mrf_waddr(MWrf_waddr),
        .Mrf_wena(MWrf_wena),
        .Mhi_wena(MWhi_wena),
        .Mlo_wena(MWlo_wena),
        .Mhi_select(MWhi_select),
        .Mlo_select(MWlo_select),
        .Mrd_select(MWrd_select),
        .Walu(Walu),
        .Wproduct(Wproduct),
        .Wquotient(Wquotient),
        .Wremainder(Wremainder),
        .Wcount_zeros(Wcount_zeros),
        .Whi(Whi),
        .Wlo(Wlo),
        .Wrs(Wrs),
        .Wdmem_rdata(Wdmem_rdata),
        .Wcp0_rdata(Wcp0_rdata),
        .Wlink_addr(Wlink_addr),
        .Wrf_waddr(Wrf_waddr),
        .Wrf_wena(Wrf_wena),
        .Whi_wena(Whi_wena),
        .Wlo_wena(Wlo_wena),
        .Whi_select(Whi_select),
        .Wlo_select(Wlo_select),
        .Wrd_select(Wrd_select)
    );

    // WB: write back
    PipeWB WB(
        .alu_i(Walu),
        .product_i(Wproduct),
        .quotient_i(Wquotient),
        .remainder_i(Wremainder),
        .count_zeros_i(Wcount_zeros),
        .hi_i(Whi),
        .lo_i(Wlo),
        .rs_i(Wrs),
        .dmem_rdata_i(Wdmem_rdata),
        .cp0_rdata_i(Wcp0_rdata),
        .link_addr_i(Wlink_addr),
        .rf_waddr_i(Wrf_waddr),
        .rf_wena_i(Wrf_wena),
        .hi_wena_i(Whi_wena),
        .lo_wena_i(Wlo_wena),
        .hi_select_i(Whi_select),
        .lo_select_i(Wlo_select),
        .rd_select_i(Wrd_select),
        .rf_wena_o(Drf_wena),
        .hi_wena_o(Dhi_wena),
        .lo_wena_o(Dlo_wena),
        .rf_wdata_o(Drf_wdata),
        .hi_wdata_o(Dhi_wdata),
        .lo_wdata_o(Dlo_wdata),
        .rf_waddr_o(Drf_waddr)
    );

endmodule