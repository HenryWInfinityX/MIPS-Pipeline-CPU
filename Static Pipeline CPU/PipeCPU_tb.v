`timescale 1ns / 1ps

module CPU_Test;
    reg clk;
    reg rst;
    wire [31:0] pc;
    wire [31:0] instr;
    wire [31:0] data_out;
 
    integer file_output;
    integer count = 0;

    PipeCPU pipecpu(
        .clk(clk),
        .rst(rst),
        .pc_o(pc),
        .instruction_o(instr),
        .data_out(data_out)
    );

    initial
    begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        #10
        rst = 0;
        file_output = $fopen("result.txt");
        //$fclose(file_output);
    end
        
    always #10 clk = ~clk;
    always @(posedge clk) 
    begin
        count <= count + 1;
        if (count == 100000)
            $fclose(file_output);
        if (rst == 0) 
        begin
            $fdisplay(file_output,"pc = %h",pc);
            $fdisplay(file_output,"instr = %h",instr);
            $fdisplay(file_output,"stall = %h",pipecpu.stall);
            $fdisplay(file_output,"regfiles0 = %h",pipecpu.ID.regfile.array_reg[0]);
            $fdisplay(file_output,"regfiles1 = %h",pipecpu.ID.regfile.array_reg[1]);
            $fdisplay(file_output,"regfiles2 = %h",pipecpu.ID.regfile.array_reg[2]);
            $fdisplay(file_output,"regfiles3 = %h",pipecpu.ID.regfile.array_reg[3]);
            $fdisplay(file_output,"regfiles4 = %h",pipecpu.ID.regfile.array_reg[4]);
            $fdisplay(file_output,"regfiles5 = %h",pipecpu.ID.regfile.array_reg[5]);
            $fdisplay(file_output,"regfiles6 = %h",pipecpu.ID.regfile.array_reg[6]);
            $fdisplay(file_output,"regfiles7 = %h",pipecpu.ID.regfile.array_reg[7]);
            $fdisplay(file_output,"regfiles8 = %h",pipecpu.ID.regfile.array_reg[8]);
            $fdisplay(file_output,"regfiles9 = %h",pipecpu.ID.regfile.array_reg[9]);
            $fdisplay(file_output,"regfiles10 = %h",pipecpu.ID.regfile.array_reg[10]);
            $fdisplay(file_output,"regfiles11 = %h",pipecpu.ID.regfile.array_reg[11]);
            $fdisplay(file_output,"regfiles12 = %h",pipecpu.ID.regfile.array_reg[12]);
            $fdisplay(file_output,"regfiles13 = %h",pipecpu.ID.regfile.array_reg[13]);
            $fdisplay(file_output,"regfiles14 = %h",pipecpu.ID.regfile.array_reg[14]);
            $fdisplay(file_output,"regfiles15 = %h",pipecpu.ID.regfile.array_reg[15]);
            $fdisplay(file_output,"regfiles16 = %h",pipecpu.ID.regfile.array_reg[16]);
            $fdisplay(file_output,"regfiles17 = %h",pipecpu.ID.regfile.array_reg[17]);
            $fdisplay(file_output,"regfiles18 = %h",pipecpu.ID.regfile.array_reg[18]);
            $fdisplay(file_output,"regfiles19 = %h",pipecpu.ID.regfile.array_reg[19]);
            $fdisplay(file_output,"regfiles20 = %h",pipecpu.ID.regfile.array_reg[20]);
            $fdisplay(file_output,"regfiles21 = %h",pipecpu.ID.regfile.array_reg[21]);
            $fdisplay(file_output,"regfiles22 = %h",pipecpu.ID.regfile.array_reg[22]);
            $fdisplay(file_output,"regfiles23 = %h",pipecpu.ID.regfile.array_reg[23]);
            $fdisplay(file_output,"regfiles24 = %h",pipecpu.ID.regfile.array_reg[24]);
            $fdisplay(file_output,"regfiles25 = %h",pipecpu.ID.regfile.array_reg[25]);
            $fdisplay(file_output,"regfiles26 = %h",pipecpu.ID.regfile.array_reg[26]);
            $fdisplay(file_output,"regfiles27 = %h",pipecpu.ID.regfile.array_reg[27]);
            $fdisplay(file_output,"regfiles28 = %h",pipecpu.ID.regfile.array_reg[28]);
            $fdisplay(file_output,"regfiles29 = %h",pipecpu.ID.regfile.array_reg[29]);
            $fdisplay(file_output,"regfiles30 = %h",pipecpu.ID.regfile.array_reg[30]);
            $fdisplay(file_output,"regfiles31 = %h",pipecpu.ID.regfile.array_reg[31]);
        end
    end

endmodule
