`timescale 1ns / 1ps

module PCReg(
    input clk,  //1位输入，寄存器时钟信号，上升沿时为PC寄存器赋值
    input rst,  //1位输入，异步重置信号，高电平时将PC寄存器清零
                //注：当ena信号无效时。rst也可以重置寄存器
    input ena,  //1位输入，有效信号高电平时PC寄存器读入data_in的值，否则保持原有输出
    input [31:0] data_in,   //32位输入，输入数据将被存入寄存器内部
    output [31:0] data_out  //32位输出，工作时始终输出PC寄存器内部存储的值
    );
    reg [31:0] program_counter;

    always @ (posedge clk or posedge rst) 
    begin
        if (rst == 1)
            program_counter <= 32'h0040_0000;
        else if (ena)
            program_counter <= data_in;
        else
            program_counter <= program_counter;
    end

    assign data_out = program_counter;
endmodule
