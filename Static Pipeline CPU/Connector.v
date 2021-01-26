`timescale 1ns / 1ps

module Connector(
    input [3:0] pc,
    input [25:0] instr,
    output [31:0] data_out
);

    assign data_out = {pc, instr, 2'b00};
    
endmodule