`timescale 1ns / 1ps

// ID 级部�?
// CU、Regfiles、CP0、HI、LO、分支指令比较器、EXT、计算转移地�?的加法器、MUX
// 输入�? WB 传回的写信号、写地址和写数据，IF 级的传�??
// 输出各类控制信号、向 EXE 级传递各类寄存器读出的�??
module PipeID(
    input clk,
    input rst,
    input [31:0] pc4_i,
    input [31:0] instruction_i,
    input [31:0] rf_wdata_i,
    input [4:0] rf_waddr_i,
    input rf_wena_i,
    input [31:0] hi_wdata_i,
    input [31:0] lo_wdata_i,
    // NEW
    input [31:0] Ealu_i,
    input [31:0] Ecount_zeros_i,
    input [63:0] Eproduct_i,
    input [31:0] Equotient_i,
    input [31:0] Eremainder_i,
	input [31:0] Elink_addr_i,
	input [31:0] Ecp0_rdata_i,
	input [31:0] Ers_i,
    input [31:0] Ehi_i,
    input [31:0] Elo_i,
	input [1:0] Ehi_select_i,
	input [1:0] Elo_select_i,
	input [2:0] Erd_select_i,
	input [4:0] Erf_waddr_i,
    input Erf_wena_i,
    input Ehi_wena_i,
    input Elo_wena_i,
    input [53:0] Ecode_i,
    input [31:0] Malu_i,
    input [31:0] Mcount_zeros_i,
    input [63:0] Mproduct_i,
    input [31:0] Mquotient_i,
    input [31:0] Mremainder_i,
	input [31:0] Mlink_addr_i,
	input [31:0] Mcp0_rdata_i,
    input [31:0] Mdmem_rdata_i,
	input [31:0] Mrs_i,
    input [31:0] Mhi_i,
    input [31:0] Mlo_i,
	input [1:0] Mhi_select_i,
	input [1:0] Mlo_select_i,
	input [2:0] Mrd_select_i,
    input [4:0] Mrf_waddr_i,
    input Mrf_wena_i,
    input Mhi_wena_i,
    input Mlo_wena_i,
    // end of NEW
    output [31:0] branch_addr_o,
    output [31:0] jump_addr_o,
    output [31:0] rs_addr_o,
    output [31:0] cp0_addr_o,
    output [31:0] link_addr_o,
    output [31:0] rs_o,
    output [31:0] rt_o,
    output [31:0] imm16_ext_o,
    output [3:0] aluc_o,
    output [31:0] cp0_rdata_o,
    output [31:0] hi_o,
    output [31:0] lo_o,
    output [4:0] rf_waddr_o,
    output stall_o,
    output [31:0] reg28_o,
    output rf_wena_o,
    output hi_wena_o,
    output lo_wena_o,
    output dmem_wena_o,
    output dmem_rena_o,
    output sign_o,
    output load_sign_o,
    output a_select_o,
    output b_select_o,
    output [2:0] pc_select_o,
    output [2:0] load_select_o,
    output [2:0] store_select_o,
    output [1:0] hi_select_o,
    output [1:0] lo_select_o,
    output [2:0] rd_select_o,
    // NEW
    output [53:0] code_o
);

    reg [1:0] stall_count;

    wire stall;
    wire [1:0] stall_count_in, stall_count_out;

    wire [3:0] aluc;
    wire [31:0] rs, rt;
    wire [4:0] rsc, rtc, rdc;
    wire [31:0] imm18_ext;
    wire mfc0, mtc0, eret, exception;
    wire [4:0] cause;
    wire [31:0] status;
    wire [1:0] comparer_select;
    wire is_branch, is_teq;
    wire rf_wena, hi_wena, lo_wena;
    wire dmem_wena, dmem_rena;
    wire ext16_sign;
    wire sign;
    wire load_sign;
    wire [2:0] pc_select;
    wire a_select, b_select;
    wire [2:0] load_select, store_select;
    wire [1:0] hi_select, lo_select;
    wire [2:0] rd_select;

	// New
    wire [53:0] code;
    wire [31:0] hi, lo;

	wire [31:0] Ehi_wdata, Elo_wdata;
	wire [31:0] Erf_wdata;
	wire [31:0] Mhi_wdata, Mlo_wdata;
	wire [31:0] Mrf_wdata;
    wire [31:0] DFrs, DFrt;
    wire [31:0] DFhi, DFlo;
    wire is_rs, is_rt;
    wire is_stall, is_data_forwarding;
	// end of NEW

    assign rsc = instruction_i[25:21];
    assign rtc = instruction_i[20:16];

    assign rs_addr_o = rs;
    assign aluc_o = aluc;
    // NEW
    assign rs_o = (is_rs && is_data_forwarding)? DFrs: rs;
    assign rt_o = (is_rt && is_data_forwarding)? DFrt: rt;
    assign hi_o = (is_data_forwarding)? DFhi: hi;
    assign lo_o = (is_data_forwarding)? DFlo: lo;
    // end of NEW
    assign link_addr_o = pc4_i;
    assign rf_waddr_o = rdc;
    // CHANGED
    assign rf_wena_o = rf_wena;
    assign hi_wena_o = hi_wena;
    assign lo_wena_o = lo_wena;
    assign dmem_wena_o = dmem_wena;
    // END OF CHANGED
    assign dmem_rena_o = dmem_rena;
    assign sign_o = sign;
    assign pc_select_o = pc_select;
    assign load_sign_o = load_sign;
    assign a_select_o = a_select;
    assign b_select_o = b_select;
    assign load_select_o = load_select;
    assign store_select_o = store_select;
    assign hi_select_o = hi_select;
    assign lo_select_o = lo_select;
    assign rd_select_o = rd_select;
    // changed
    assign stall_o = is_stall;

    assign code_o = code;

    // 处理暂停
    //assign stall_count_in = stall_count;

 	// new
    MUX4_1 mux_exe_hi(
        .a(32'h0),
        .b(Ers_i),
        .c(Eproduct_i[63:32]),
        .d(Eremainder_i),
        .select(Ehi_select_i),
        .r(Ehi_wdata)
    );

    MUX4_1 mux_exe_lo(
        .a(32'h0),
        .b(Ers_i),
        .c(Eproduct_i[31:0]),
        .d(Equotient_i),
        .select(Elo_select_i),
        .r(Elo_wdata)
    );

    MUX8_1 mux_exe_rd(
        .a(Elink_addr_i),
        .b(Ealu_i),
        .c(Ecount_zeros_i),
        .d(Ehi_i),
        .e(Elo_i),
        .f(32'h0), //
        .g(Ecp0_rdata_i), //
        .h(Eproduct_i[31:0]),
        .select(Erd_select_i),
        .r(Erf_wdata)
    );

    MUX4_1 mux_mem_hi(
        .a(32'h0),
        .b(Mrs_i),
        .c(Mproduct_i[63:32]),
        .d(Mremainder_i),
        .select(Mhi_select_i),
        .r(Mhi_wdata)
    );

    MUX4_1 mux_mem_lo(
        .a(32'h0),
        .b(Mrs_i),
        .c(Mproduct_i[31:0]),
        .d(Mquotient_i),
        .select(Mlo_select_i),
        .r(Mlo_wdata)
    );

    MUX8_1 mux_mem_rd(
        .a(Mlink_addr_i),
        .b(Malu_i),
        .c(Mcount_zeros_i),
        .d(Mhi_i),
        .e(Mlo_i),
        .f(Mdmem_rdata_i),
        .g(Mcp0_rdata_i), //
        .h(Mproduct_i[31:0]),
        .select(Mrd_select_i),
        .r(Mrf_wdata)
    );
    
    DataForwarding data_forwarding(
    	.clk(clk),
    	.rst(rst),
    	.code_i(code),
    	.rsc_i(rsc),
    	.rtc_i(rtc),
    	.Erf_waddr_i(Erf_waddr_i),
    	.Erf_wdata_i(Erf_wdata_i),
    	.Ehi_wdata_i(Ehi_wdata_i),
    	.Elo_wdata_i(Elo_wdata_i),
    	.Erf_wena_i(Erf_wena_i),
    	.Ehi_wena_i(Ehi_wena_i),
    	.Elo_wena_i(Elo_wena_i),
    	.Ecode_i(Ecode_i),
        .Mrf_waddr_i(Mrf_waddr_i),
    	.Mrf_wdata_i(Mrf_wdata_i),
    	.Mhi_wdata_i(Mhi_wdata_i),
    	.Mlo_wdata_i(Mlo_wdata_i),
    	.Mrf_wena_i(Mrf_wena_i),
    	.Mhi_wena_i(Mhi_wena_i),
    	.Mlo_wena_i(Mlo_wena_i),
        .is_rs_o(is_rs),
        .is_rt_o(is_rt),
        .is_stall_o(is_stall),
        .is_data_forwarding_o(is_data_forwarding),
        .rs_o(DFrs),
        .rt_o(DFrt),
        .hi_o(DFhi),
        .lo_o(DFlo)
    );

    EXT16 ext_imm16(
        .a(instruction_i[15:0]),
        .sign(ext16_sign),
        .b(imm16_ext_o)
    );

    // 实际上，HI、LO 的读�? EXE 阶段进行，写�? WB 阶段进行
    Reg HI(
        .clk(clk),
        .rst(rst),
        .ena(hi_wena),
        .data_in(hi_wdata_i),
        .data_out(hi)
    );

    Reg LO(
        .clk(clk),
        .rst(rst),
        .ena(lo_wena),
        .data_in(lo_wdata_i),
        .data_out(lo)
    );

    Regfile regfile(
        .clk(clk),
        .rst(rst),
        .we(rf_wena_i),
        .raddr1(rsc),
        .raddr2(rtc),
        .waddr(rf_waddr_i),
        .wdata(rf_wdata_i),
        .rdata1(rs),
        .rdata2(rt),
        .reg28(reg28_o)
    );

    CP0 cp0(
        .clk(clk),
        .rst(rst),
        .pc(pc4_i),
        .mfc0(mfc0),
        .mtc0(mtc0),
        .eret(eret),
        .exception(exception),
        .wdata(rt),
        .addr(rtc),
        .cause(cause),
        .rdata(cp0_rdata_o),
        .status(status),
        .exception_addr(cp0_addr_o)
    );

    Comparer comparer(
        .data_in1(rs),
        .data_in2(rt),
        .comparer_select(comparer_select),
        .is_branch(is_branch),
        .is_teq(is_teq)
    );

    EXT18 ext_imm18(
        .a(instruction_i[15:0]),
        .b(imm18_ext)
    );

    Adder branch_addr(
        .a(pc4_i),
        .b(imm18_ext),
        .r(branch_addr_o)
    );

    Connector connector(
        .pc(pc4_i[31:28]),
        .instr(instruction_i[25:0]),
        .data_out(jump_addr_o)
    );

    CU control_unit(
        .instr(instruction_i),
        .rsc(rsc),
        .rtc(rtc),
        //.stall_count_in(stall_count_in),
        .is_branch(is_branch),
        .is_teq(is_teq),
        //.Erf_waddr(Erf_waddr_i),
        //.Erf_wena(Erf_wena_i),
        //.Ehi_wena(Ehi_wena_i),
        //.Elo_wena(Elo_wena_i),
        //.Mrf_waddr(Mrf_waddr_i),
        //.Mrf_wena(Mrf_wena_i),
        //.Mhi_wena(Mhi_wena_i),
        //.Mlo_wena(Mlo_wena_i),
        .rdc(rdc),
        .ext16_sign(ext16_sign),
        .aluc(aluc),
        .mfc0(mfc0),
        .mtc0(mtc0),
        .eret(eret),
        .exception(exception),
        .cause(cause),
        .hi_wena(hi_wena),
        .lo_wena(lo_wena),
        .rf_wena(rf_wena),
        .dmem_wena(dmem_wena),
        .dmem_rena(dmem_rena),
        .sign(sign),
        .load_sign(load_sign),
        .a_select(a_select),
        .b_select(b_select),
        .pc_select(pc_select),
        .comparer_select(comparer_select),
        .load_select(load_select),
        .store_select(store_select),
        .hi_select(hi_select),
        .lo_select(lo_select),
        .rd_select(rd_select),
        // NEW
        .code(code)
        //.stall(stall),
        //.stall_count_out(stall_count_out)
    );

    /*
    // 处理暂停
    // ? always @ (posedge clk or posedge rst)
    always @ (posedge stall)
    begin
        stall_count <= stall_count_out;
    end

    always @ (posedge clk or posedge rst)
    begin
        if (rst)
        begin
            stall_count <= 2'b00;
        end
        else
        begin
            if (stall_count != 2'b00)
            begin
                stall_count <= stall_count - 1;
            end
        end
    end
    */

endmodule