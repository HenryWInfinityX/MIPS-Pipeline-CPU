`timescale 1ns / 1ps

module DMEM(
    input clk,
    input rena,
    input wena,
    input [2:0] store_select,
    input [31:0] addr,
    input [31:0] data_in,
    output reg [31:0] data_out
    );
    //reg [31:0] memory[1023:0];
    reg [7:0] memory[1023:0];

    //wire [31:0] actual_addr;
    //wire [31:0] data;
    wire [7:0] actual_addr;

    assign actual_addr = (addr - 32'h1001_0000);
    //assign data = memory[actual_addr];

    always @ (posedge clk)
    begin
        if (rena)
            //data_out <= memory[actual_addr];
            data_out <= {memory[actual_addr], memory[actual_addr + 1], memory[actual_addr + 2], memory[actual_addr + 3]};
        if (wena) begin
            if (store_select == 3'b001) begin
                //SB
                //memory[actual_addr] <= {data_in[7:0], data[23:0]}; //7:0
                memory[actual_addr] = data_in[7:0];
            end
            else if (store_select == 3'b010) begin
                //SH
                //memory[actual_addr] <= {data_in[15:0], data[15:0]}; //15:0
                memory[actual_addr] = data_in[15:8];
                memory[actual_addr + 1] = data_in[7:0];
            end
            else if (store_select == 3'b100) begin
                //SW
                //memory[actual_addr] <= data_in;
                memory[actual_addr] = data_in[31:24];
                memory[actual_addr + 1] = data_in[23:16];
                memory[actual_addr + 2] = data_in[15:8];
                memory[actual_addr + 3] = data_in[7:0];
            end
        end
    end
endmodule
