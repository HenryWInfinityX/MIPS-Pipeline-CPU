`timescale 1ns / 1ps

module Counter(
    input [31:0] data_in,
    output [31:0] data_out
);

    reg [31:0] cnt;

    assign data_out = cnt;

    always @ *
    begin
        if (data_in[31])
            cnt = 32'd0;
        else if (data_in[30])
            cnt = 32'd1;
        else if (data_in[29])
            cnt = 32'd2;
        else if (data_in[28])
            cnt = 32'd3;
        else if (data_in[27])
            cnt = 32'd4;
        else if (data_in[26])
            cnt = 32'd5;
        else if (data_in[25])
            cnt = 32'd6;
        else if (data_in[24])
            cnt = 32'd7;
        else if (data_in[23])
            cnt = 32'd8;
        else if (data_in[22])
            cnt = 32'd9;
        else if (data_in[21])
            cnt = 32'd10;
        else if (data_in[20])
            cnt = 32'd11;
        else if (data_in[19])
            cnt = 32'd12;
        else if (data_in[18])
            cnt = 32'd13;
        else if (data_in[17])
            cnt = 32'd14;
        else if (data_in[16])
            cnt = 32'd15;
        else if (data_in[15])
            cnt = 32'd16;
        else if (data_in[14])
            cnt = 32'd17;
        else if (data_in[13])
            cnt = 32'd18;
        else if (data_in[12])
            cnt = 32'd19;
        else if (data_in[11])
            cnt = 32'd20;
        else if (data_in[10])
            cnt = 32'd21;
        else if (data_in[9])
            cnt = 32'd22;
        else if (data_in[8])
            cnt = 32'd23;
        else if (data_in[7])
            cnt = 32'd24;
        else if (data_in[6])
            cnt = 32'd25;
        else if (data_in[5])
            cnt = 32'd26;
        else if (data_in[4])
            cnt = 32'd27;
        else if (data_in[3])
            cnt = 32'd28;
        else if (data_in[2])
            cnt = 32'd29;
        else if (data_in[1])
            cnt = 32'd30;
        else if (data_in[0])
            cnt = 32'd31;
        else
            cnt = 32'd32;
    end

endmodule