`timescale 1ns / 1ps

module PCReg(
    input clk,  //1λ���룬�Ĵ���ʱ���źţ�������ʱΪPC�Ĵ�����ֵ
    input rst,  //1λ���룬�첽�����źţ��ߵ�ƽʱ��PC�Ĵ�������
                //ע����ena�ź���Чʱ��rstҲ�������üĴ���
    input ena,  //1λ���룬��Ч�źŸߵ�ƽʱPC�Ĵ�������data_in��ֵ�����򱣳�ԭ�����
    input [31:0] data_in,   //32λ���룬�������ݽ�������Ĵ����ڲ�
    output [31:0] data_out  //32λ���������ʱʼ�����PC�Ĵ����ڲ��洢��ֵ
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
