`timescale 1ns / 1ps

module Comparer(
    input [31:0] data_in1,
    input [31:0] data_in2,
    input [1:0] comparer_select,
    output reg is_branch,
    output reg is_teq
);

    always @ (*)
    begin
        // beq
        if (comparer_select == 2'b00)
            is_branch <= (data_in1 == data_in2)?1'b1: 1'b0;
        // bne
        else if (comparer_select == 2'b01)
            is_branch <= (data_in1 != data_in2)?1'b1: 1'b0;
        // bgez
        else if (comparer_select == 2'b10)
            is_branch <= (data_in1 >= 0)?1'b1: 1'b0;
        // teq
        else if (comparer_select == 2'b11)
            is_teq <= (data_in1 == data_in2)?1'b1: 1'b0;
    end

endmodule