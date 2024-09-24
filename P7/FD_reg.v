`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:54:55 11/08/2023 
// Design Name: 
// Module Name:    FD_reg 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FD_reg(
    input clk,
	 input reset,
	 input stall,
	 input Req,
	 input [31:0] F_PC,
	 input [31:0] F_Instr,
	 input [4:0] F_exception_code,
	 input F_isDelay,
	 output reg [31:0] D_PC,
	 output reg [31:0] D_Instr,
	 output reg [4:0] D_temp_exception_code,
	 output reg D_isDelay
    );
always@(posedge clk) begin//reset>Req>stall/flush
    if(reset|Req) begin // clear FD registers or insert nop
		  D_PC<= Req? 32'h0000_4180:0;
		  D_Instr<=0;//nop
		  D_temp_exception_code<=0;
		  D_isDelay<=0;
	 end
	 else begin
	 if(stall==0) begin //pipeline;
		  D_PC<=F_PC;
		  D_Instr<=F_Instr;
		  D_temp_exception_code<=F_exception_code;
		  D_isDelay<=F_isDelay;
	 end
	 end
end

endmodule
