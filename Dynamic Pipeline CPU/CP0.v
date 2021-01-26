`timescale 1ns / 1ps

module CP0(
    input clk,
    input rst,
    input [31:0] pc,
    input mfc0,
    input mtc0,
    input eret,
    input exception,
    input [31:0] wdata,
    input [4:0] addr,
    input [4:0] cause,
    output [31:0] rdata,
    output [31:0] status,
    output [31:0] exception_addr
);
    
    parameter Status = 12;
    parameter Cause = 13;
    parameter Epc = 14;

    reg [31:0] cp0_reg [31:0]; //CP0的32个寄存器
    
    assign status = cp0_reg[Status];
    assign exception_addr = eret? cp0_reg[Epc]: 32'h0040_0004;
    assign rdata = mfc0? cp0_reg[addr]: 32'hz;

    always @(posedge clk or posedge rst)
    begin
        if (rst) begin 
            cp0_reg [0] <= 0;
            cp0_reg [1] <= 0;
            cp0_reg [2] <= 0;
            cp0_reg [3] <= 0;
            cp0_reg [4] <= 0;
            cp0_reg [5] <= 0;
            cp0_reg [6] <= 0;
            cp0_reg [7] <= 0;
            cp0_reg [8] <= 0;
            cp0_reg [9] <= 0;
            cp0_reg [10] <= 0;
            cp0_reg [11] <= 0;
            cp0_reg [12] <= 0;
            cp0_reg [13] <= 0;
            cp0_reg [14] <= 0;
            cp0_reg [15] <= 0;
            cp0_reg [16] <= 0;
            cp0_reg [17] <= 0;
            cp0_reg [18] <= 0;
            cp0_reg [19] <= 0;
            cp0_reg [20] <= 0;
            cp0_reg [21] <= 0;
            cp0_reg [22] <= 0;
            cp0_reg [23] <= 0;
            cp0_reg [24] <= 0;
            cp0_reg [25] <= 0;
            cp0_reg [26] <= 0;
            cp0_reg [27] <= 0;
            cp0_reg [28] <= 0;
            cp0_reg [29] <= 0;
            cp0_reg [30] <= 0;
            cp0_reg [31] <= 0;        
        end
        else begin
            if (mtc0)
                cp0_reg[addr] <= wdata;
            else if (exception) begin
                cp0_reg[Status] <= status << 5;
                cp0_reg[Cause] <= {24'b0, cause, 2'b0};
                cp0_reg[Epc] <= pc;
            end
            else if (eret) begin
                cp0_reg[Status] <= status >> 5;
            end
        end
    end
endmodule
