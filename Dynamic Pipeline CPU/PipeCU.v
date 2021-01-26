`timescale 1ns / 1ps

module CU(
    input [31:0] instr,
    input [4:0] rsc,
    input [4:0] rtc,
    //input [1:0] stall_count_in,
    input is_branch,
    input is_teq,
    input [4:0] Erf_waddr,
    //input Erf_wena,
    //input Ehi_wena,
    //input Elo_wena,
    //input [4:0] Mrf_waddr,
    //input Mrf_wena,
    //input Mhi_wena,
    //input Mlo_wena,
    output [4:0] rdc,
    output ext16_sign,
    output [3:0] aluc,
    output mfc0,
    output mtc0,
    output eret,
    output exception,
    output [4:0] cause,
    output hi_wena,
    output lo_wena,
    output rf_wena,
    output dmem_wena,
    output dmem_rena,
    output sign,
    output load_sign,
    output a_select,
    output b_select,
    output [2:0] pc_select,
    output [1:0] comparer_select,
    output [2:0] load_select,
    output [2:0] store_select,
    output [1:0] hi_select,
    output [1:0] lo_select,
    output [2:0] rd_select,
    output [53:0] code
    //output stall,
    //output [1:0] stall_count_out
);

    parameter Add     = 0;
    parameter Addu    = 1;
    parameter Sub     = 2;
    parameter Subu    = 3;
    parameter And     = 4;
    parameter Or      = 5;
    parameter Xor     = 6;
    parameter Nor     = 7;
    parameter Slt     = 8;
    parameter Sltu    = 9;
    parameter Sll     = 10;
    parameter Srl     = 11;
    parameter Sra     = 12;
    parameter Sllv    = 13;
    parameter Srlv    = 14;
    parameter Srav    = 15;
    parameter Jr      = 16;
    parameter Addi    = 17;
    parameter Addiu   = 18;
    parameter Andi    = 19;
    parameter Ori     = 20;
    parameter Xori    = 21;
    parameter Lw      = 22;
    parameter Sw      = 23;
    parameter Beq     = 24;
    parameter Bne     = 25;
    parameter Slti    = 26;
    parameter Sltiu   = 27;
    parameter Lui     = 28;
    parameter J       = 29;
    parameter Jal     = 30;
    parameter Clz     = 31;
    parameter Divu    = 32;
    parameter Eret    = 33;
    parameter Jalr    = 34;
    parameter Lb      = 35;
    parameter Lbu     = 36;
    parameter Lhu     = 37;
    parameter Sb      = 38;
    parameter Sh      = 39;
    parameter Lh      = 40;
    parameter Mfc0    = 41;
    parameter Mfhi    = 42;
    parameter Mflo    = 43;
    parameter Mtc0    = 44;
    parameter Mthi    = 45;
    parameter Mtlo    = 46;
    parameter Mul     = 47;
    parameter Multu   = 48;
    parameter Syscall = 49;
    parameter Teq     = 50;
    parameter Bgez    = 51;
    parameter Break   = 52;
    parameter Div     = 53;

    //wire [53:0] code;
    wire is_mfc0, is_mtc0;
    wire is_alu;
    //wire is_rs, is_rt;
    //wire is_stall;

    InstructionDecode id(
        .instruction(instr),
        .code(code)
    );

    assign is_mfc0 = (code[Mfc0] && instr[25:21] == 5'b00000)? 1'b1: 1'b0;
    assign is_mtc0 = (code[Mtc0] && instr[25:21] == 5'b00100)? 1'b1: 1'b0;

    // to IF
    assign pc_select = (code[Beq] | code[Bne] | code[Bgez]) & is_branch? 3'b001:
                       (code[J] | code[Jal])? 3'b010:
                       (code[Jr] | code[Jalr])? 3'b011:
                       (code[Eret])? 3'b100:
                       (code[Syscall] | (code[Teq] & is_teq) | code[Break])? 3'b101:
                       3'b000;

    // to ID
    assign mfc0 = is_mfc0;
    assign mtc0 = is_mtc0;
    assign eret = code[Eret];
    assign exception = code[Syscall] | (code[Teq] & is_teq) | code[Break];
    assign cause = code[Syscall]? 5'b01000:
                   (code[Teq] & is_teq)? 5'b01101:
                   code[Break]? 5'b01001:
                   5'b00000;

    assign comparer_select = code[Beq]? 2'b00:
                             code[Bne]? 2'b01:
                             code[Bgez]? 2'b10:
                             code[Teq]? 2'b11:
                             2'bz;

    assign rdc = (code[Jal] | code[Jalr])? 5'b11111:
                 (code[Addi] | code[Addiu] | code[Andi] | code[Ori] | code[Xori] | code[Lw] | code[Sw] | code[Slti] | code[Sltiu] | code[Lui] | code[Lb] | code[Lbu] | code[Lh] | code[Lhu] | code[Sb] | code[Sh] | is_mfc0)? instr[20:16]:
                 instr[15:11];

    assign ext16_sign = ~(code[Andi] | code[Ori] | code[Xori]);
    assign hi_wena = code[Div] | code[Divu] | code[Mul] | code[Multu] | code[Mthi];
    assign lo_wena = code[Div] | code[Divu] | code[Mul] | code[Multu] | code[Mtlo];
    assign rf_wena = ~(code[Jr] | code[Sw] | code[Beq] | code[Bne] | code[J] | code[Divu] | code[Eret] | code[Sb] | code[Sh] | is_mtc0 | code[Mthi] | code[Mtlo] | code[Multu] | code[Syscall] | code[Teq] | code[Bgez] | code[Break] | code[Div]);
    // to EXE
    assign aluc[0] = code[Sub] | code[Subu] | code[Or] | code[Nor] | code[Slt] | code[Srl] | code[Srlv] | code[Ori] | code[Beq] | code[Bne] | code[Slti] | code[Teq];
    assign aluc[1] = code[Add] | code[Sub] | code[Xor] | code[Nor] | code[Slt] | code[Sltu] | code[Sll] | code[Sllv] | code[Addi] | code[Xori] | code[Lw] | code[Sw] | code[Beq] | code[Bne] | code[Slti] | code[Sltiu];
    assign aluc[2] = code[And] | code[Or] | code[Xor] | code[Nor] | code[Sll] | code[Srl] | code[Sra] | code[Sllv] | code[Srlv] | code[Srav] | code[Andi] | code[Ori] | code[Xori];
    assign aluc[3] = code[Slt] | code[Sltu] | code[Sll] | code[Srl] | code[Sra] | code[Sllv] | code[Srlv] | code[Srav] | code[Slti] | code[Sltiu] | code[Lui];
    assign sign = code[Div] | code[Mul];
    assign a_select = code[Sll] | code[Srl] | code[Sra] | code[Sllv] | code[Srlv] | code[Srav];
    assign b_select = code[Addi] | code[Addiu] | code[Andi] | code[Ori] | code[Xori] | code[Lw] | code[Sw] | code[Slti] | code[Sltiu] | code[Lui];
    // to MEM
    assign dmem_rena = code[Lw] | code[Lh] | code[Lhu] | code[Lb] | code[Lbu];
    assign dmem_wena = code[Sw] | code[Sh] | code[Sb];
    assign load_sign = code[Lw] | code[Lh] | code[Lb];

    assign load_select = code[Lh]? 3'b001:
                         code[Lb]? 3'b010:
                         code[Lbu]? 3'b011:
                         code[Lhu]? 3'b100:
                         code[Lw]? 3'b000:
                         3'bz;

    assign store_select = code[Sb]? 3'b001:
                          code[Sh]? 3'b010:
                          code[Sw]? 3'b100:
                          3'b000;
    // to WB
    assign hi_select = (code[Mthi])? 2'b01:
                       (code[Mul] | code[Multu])? 2'b10:
                       (code[Div] | code[Divu])? 2'b11:
                       2'b00;

    assign lo_select = (code[Mtlo])? 2'b01:
                       (code[Mul] | code[Multu])? 2'b10:
                       (code[Div] | code[Divu])? 2'b11:
                       2'b00;

    assign is_alu = code[Add] | code[Addu] | code[Sub] | code[Subu] | code[And] | code[Or] | code[Xor] | code[Nor] | code[Slt] | code[Sltu] | code[Sll] | code[Srl] | code[Sra] | code[Sllv] | code[Srlv] | code[Srav] | code[Addi] | code[Addiu] | code[Andi] | code[Ori] | code[Andi] | code[Xori] | code[Slti] | code[Sltiu] | code[Lui] | code[Beq] | code[Bne] | code[Bgez];

    assign rd_select = (is_alu)? 3'b001:
                       (code[Clz])? 3'b010:
                       (code[Mfhi])? 3'b011:
                       (code[Mflo])? 3'b100:
                       (code[Lw] | code[Lh] | code[Lhu] | code[Lb] | code[Lbu])? 3'b101:
                       (is_mfc0)? 3'b110:
                       //(code[Jal] | code[Jalr])? 3'b111:
                       (code[Mul])? 3'b111:
                       3'b000; // link

    /*
    // stall
    assign is_rs = ~(code[Sll] | code[Srl] | code[Sra] | code[Jalr] | code[Mfhi] | code[Mflo] | mfc0 | mtc0 | code[Lui] | code[J] | code[Jal] | code[Break] | code[Syscall] | code[Eret]);
    assign is_rt = code[Add] | code[Addu] | code[Sub] | code[Subu] | code[And] | code[Or] | code[Xor] | code[Nor] | code[Slt] | code[Sltu] | code[Sll] | code[Srl] | code[Sra] | code[Sllv] | code[Srlv] | code[Srav] | code[Mtc0] | code[Mul] | code[Multu] | code[Div] | code[Divu] | code[Sw] | code[Sh] | code[Sb] | code[Beq] | code[Bne] | code[Teq];
    assign is_stall = (Erf_wena && Erf_waddr && (is_rs && (rsc == Erf_waddr) || is_rt && (rtc == Erf_waddr))) || (Ehi_wena && code[Mfhi]) || (Elo_wena && code[Mflo]) ||
                      (Mrf_wena && Mrf_waddr && (is_rs && (rsc == Mrf_waddr) || is_rt && (rtc == Mrf_waddr))) || (Mhi_wena && code[Mfhi]) || (Mlo_wena && code[Mflo]);

    assign stall = is_stall;
    // 若冲突在 EXE 则暂停 3 周期；在 MEM 暂停 2 周期
    assign stall_count_out[0] = (Erf_wena && Erf_waddr && (is_rs && (rsc == Erf_waddr) || is_rt && (rtc == Erf_waddr))) || (Ehi_wena && code[Mfhi]) || (Elo_wena && code[Mflo]);
    assign stall_count_out[1] = is_stall;
    */

endmodule