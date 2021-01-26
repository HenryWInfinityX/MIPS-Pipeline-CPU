`timescale 1ns / 1ps

// 寄存器
// 用于 PipeIR、PipeID
module Reg(
    input clk,
    input rst,
    input ena,
    input [31:0] data_in,
    output [31:0] data_out
);
    reg [31:0] out;
    
    assign data_out = out;
    
    always@(posedge clk or posedge rst)
	begin
		if (rst == 1) 
			out <= 32'h0000_0000;
        else if(ena)
			out <= data_in;
        else 
            out <= out;
	end

endmodule