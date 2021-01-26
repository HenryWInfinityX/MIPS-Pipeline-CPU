`timescale 1ns / 1ps

module Regfile(
    input clk,  //寄存器组时钟信号，下降沿写入数据
    input rst,  //异步复位信号，高电平时全部寄存器置零
    input we,   //寄存器读写有效信号，高电平时允许寄存器写入数据，低电平时允许寄存器读出数据
    input [4:0] raddr1,     //所需读取的寄存器的地址
    input [4:0] raddr2,     //所需读取的寄存器的地址
    input [4:0] waddr,  //写寄存器的地址
    input [31:0] wdata, //写寄存器的数据，数据在clk下降沿时被写入
    output [31:0] rdata1,    //raddr1所对应寄存器的输出数据
    output [31:0] rdata2,  //raddr2所对应寄存器的输出数据
    output [31:0] reg28
);

    reg [31:0] array_reg[31:0];      
    assign rdata1 = array_reg[raddr1];
    assign rdata2 = array_reg[raddr2];
    assign reg28 = array_reg[28];

    always @(posedge clk or posedge rst) begin                                           
        if (rst) 
        begin                               
            array_reg[0]  <= 0;          
            array_reg[1]  <= 0;
            array_reg[2]  <= 0;
            array_reg[3]  <= 0;
            array_reg[4]  <= 0;
            array_reg[5]  <= 0;
            array_reg[6]  <= 0;
            array_reg[7]  <= 0;
            array_reg[8]  <= 0;
            array_reg[9]  <= 0;
            array_reg[10] <= 0;
            array_reg[11] <= 0;
            array_reg[12] <= 0;
            array_reg[13] <= 0;
            array_reg[14] <= 0;
            array_reg[15] <= 0;
            array_reg[16] <= 0;
            array_reg[17] <= 0;
            array_reg[18] <= 0;
            array_reg[19] <= 0;
            array_reg[20] <= 0;
            array_reg[21] <= 0;
            array_reg[22] <= 0;
            array_reg[23] <= 0;
            array_reg[24] <= 0;
            array_reg[25] <= 0;
            array_reg[26] <= 0;
            array_reg[27] <= 0;
            array_reg[28] <= 0;
            array_reg[29] <= 0;
            array_reg[30] <= 0;
            array_reg[31] <= 0;
        end     
        
        else if(we)
        begin          
            if(waddr != 0)
                array_reg[waddr] <= wdata;
            else
                array_reg[0] <= 0; 
        end             
    end 
    
endmodule
