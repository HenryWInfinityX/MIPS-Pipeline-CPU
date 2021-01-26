`timescale 1ns / 1ps

// ID 级部件
// CU、Regfiles、CP0、HI、LO、分支指令比较器、EXT、计算转移地址的加法器、MUX
// 输入从 WB 传回的写信号、写地址和写数据，IF 级的传值
// 输出各类控制信号、向 EXE 级传递各类寄存器读出的值
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
    input [4:0] Erf_waddr_i,
    input Erf_wena_i,
    input Ehi_wena_i,
    input Elo_wena_i,
    input [4:0] Mrf_waddr_i,
    input Mrf_wena_i,
    input Mhi_wena_i,
    input Mlo_wena_i,
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
    output [2:0] rd_select_o
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

    assign rsc = instruction_i[25:21];
    assign rtc = instruction_i[20:16];

    assign rs_addr_o = rs;
    assign aluc_o = aluc;
    assign rs_o = rs;
    assign rt_o = rt;
    assign link_addr_o = pc4_i;
    assign rf_waddr_o = rdc;
    assign rf_wena_o = stall? 1'b0: rf_wena;
    assign hi_wena_o = stall? 1'b0: hi_wena;
    assign lo_wena_o = stall? 1'b0: lo_wena;
    assign dmem_wena_o = stall? 1'b0: dmem_wena;
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
    assign stall_o = stall;

    // 处理暂停
    assign stall_count_in = stall_count;

    EXT16 ext_imm16(
        .a(instruction_i[15:0]),
        .sign(ext16_sign),
        .b(imm16_ext_o)
    );

    // 实际上，HI、LO 的读在 EXE 阶段进行，写在 WB 阶段进行
    Reg HI(
        .clk(clk),
        .rst(rst),
        .ena(hi_wena),
        .data_in(hi_wdata_i),
        .data_out(hi_o)
    );

    Reg LO(
        .clk(clk),
        .rst(rst),
        .ena(lo_wena),
        .data_in(lo_wdata_i),
        .data_out(lo_o)
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
        .stall_count_in(stall_count_in),
        .is_branch(is_branch),
        .is_teq(is_teq),
        .Erf_waddr(Erf_waddr_i),
        .Erf_wena(Erf_wena_i),
        .Ehi_wena(Ehi_wena_i),
        .Elo_wena(Elo_wena_i),
        .Mrf_waddr(Mrf_waddr_i),
        .Mrf_wena(Mrf_wena_i),
        .Mhi_wena(Mhi_wena_i),
        .Mlo_wena(Mlo_wena_i),
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
        .stall(stall),
        .stall_count_out(stall_count_out)
    );

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

endmodule