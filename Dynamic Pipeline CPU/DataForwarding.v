`timescale 1ns / 1ps

module DataForwarding(
    input clk,
    input rst,
    input [53:0] code_i,
    input [4:0] rsc_i,
    input [4:0] rtc_i,
    // Data from EXE  
	input [4:0] Erf_waddr_i, 
    input Erf_wena_i,
    input Ehi_wena_i,
    input Elo_wena_i,
    input [31:0] Ehi_wdata_i,
    input [31:0] Elo_wdata_i,
    input [31:0] Erf_wdata_i,
    input [53:0] Ecode_i,
	// Data from MEM
	input [4:0] Mrf_waddr_i, 
    input Mrf_wena_i,
    input Mhi_wena_i,
    input Mlo_wena_i,
    input [31:0] Mhi_wdata_i,
    input [31:0] Mlo_wdata_i,
    input [31:0] Mrf_wdata_i,
    output reg is_rs_o,
    output reg is_rt_o,
    output reg is_stall_o,
    output reg is_data_forwarding_o,
    output reg [31:0] rs_o,
    output reg [31:0] rt_o,
    output reg [31:0] hi_o,
    output reg [31:0] lo_o
);

    parameter Mfhi = 42;
    parameter Mflo = 43;
    parameter Lw = 22;
    parameter Lhu = 37;
    parameter Lh = 40;
    parameter Lbu = 36;
    parameter Lb = 35;
    
    wire Eis_load;
    
    assign Eis_load = Ecode_i[Lw] | Ecode_i[Lhu] | Ecode_i[Lh] | Ecode_i[Lbu] | Ecode_i[Lb];
    
    // posedge?
    always @ (posedge clk or posedge rst)
    begin
        if (rst)
        begin
        	is_rs_o <= 0;
        	is_rt_o <= 0;
            is_stall_o <= 0;
            is_data_forwarding_o <= 0;
            rs_o <= 0;
            rt_o <= 0;
            hi_o <= 0;
            lo_o <= 0;
        end // end of rst

        else if (is_stall_o == 1'b1)
        begin
            is_stall_o <= 1'b0;
            if (is_rs_o)
            	rs_o <= Mrf_wdata_i;
            else if (is_rt_o)
            	rt_o <= Mrf_wdata_i;
        end // end of stall
        
        else if (is_stall_o == 1'b0)
        begin
        	is_rs_o <= 1'b0;
        	is_rt_o <= 1'b0;
        	is_data_forwarding_o <= 1'b0;
        	
        	if (code_i[Mfhi])
        	begin
        		if (Ehi_wena_i)
        		begin
        			is_data_forwarding_o <= 1'b1;
        			hi_o <= Ehi_wdata_i;
        		end
        		
        		else if (Mhi_wena_i)
        		begin
        			is_data_forwarding_o <= 1'b1;
        			hi_o <= Mhi_wdata_i;
        		end
        	end // end of mfhi
        	
        	else if (code_i[Mflo])
        	begin
        		if (Elo_wena_i)
        		begin
        			is_data_forwarding_o <= 1'b1;
        			lo_o <= Elo_wdata_i;
        		end
        		
        		else if (Mlo_wena_i)
        		begin
        			is_data_forwarding_o <= 1'b1;
        			lo_o <= Mlo_wdata_i;
        		end
        	end // end of mflo
        	
        	else 
        	begin
        		if (Erf_wena_i && Erf_waddr_i == rsc_i)
        		begin
        			is_rs_o <= 1'b1;
        			is_data_forwarding_o <= 1'b1;
        			if (Eis_load)
        				is_stall_o <= 1'b1;
        			else
        				rs_o <= Erf_wdata_i;
        		end // end of Ers
        		
        		else if (Erf_wena_i && Erf_waddr_i == rtc_i)
        		begin
        			is_rt_o <= 1'b1;
        			is_data_forwarding_o <= 1'b1;
        			if (Eis_load)
        				is_stall_o <= 1'b1;
        			else
        				rt_o <= Erf_wdata_i;
        		end // end of Ert
        		
        		else if (Mrf_wena_i && Mrf_waddr_i == rsc_i)
        		begin
        			is_rs_o <= 1'b1;
        			rs_o <= Mrf_wdata_i;
        		end // end of Mrs
        		
        		else if (Mrf_wena_i && Mrf_waddr_i == rtc_i)
        		begin
        			is_rt_o <= 1'b1;
        			rt_o <= Mrf_wdata_i;
        		end // end of Mrt
        	end // end of rs & rt
        end // end of not stall
    end // end of always         

endmodule