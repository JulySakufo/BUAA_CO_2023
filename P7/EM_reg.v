`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:16:38 11/08/2023 
// Design Name: 
// Module Name:    EM_reg 
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
module EM_reg(
    input clk,
    input reset,
	 input [31:0] E_PC,
	 input [31:0] E_Instr,
    input [31:0] ALUResult_in,
	 input [31:0] E_RD2,
	 input [4:0] E_A3,
	 input [1:0] E_Tnew,
	 input [31:0] HI,
	 input [31:0] LO,
	 input Req,
	 input [4:0] E_exception_code,
	 input E_isDelay,
	 input E_exception_DMOV,
    output reg [31:0] ALUResult_out,
	 output reg [31:0] M_PC,
	 output reg [31:0] M_Instr,
	 output reg [31:0] M_RD2,
	 output reg [4:0] M_A3,
	 output reg [1:0] M_Tnew,
	 output reg [31:0] M_HI,
	 output reg [31:0] M_LO,
	 output reg [4:0] M_temp_exception_code,
	 output reg M_isDelay,
	 output reg M_exception_DMOV
    );
always@(posedge clk) begin
    if(reset|Req) begin
	     ALUResult_out<=0;
		  M_PC<= Req?32'h0000_4180:0;
		  M_Instr<=0;
		  M_RD2<=0;
		  M_A3<=0;
		  M_Tnew<=0;
		  M_HI<=0;
		  M_LO<=0;
		  M_temp_exception_code<=0;
		  M_isDelay<=0;
		  M_exception_DMOV<=0;
	 end
	 else begin
	     ALUResult_out<=ALUResult_in;
		  M_PC<=E_PC;
		  M_Instr<=E_Instr;
		  M_RD2<=E_RD2;
		  M_A3<=E_A3;
		  M_HI<=HI;
		  M_LO<=LO;
		  M_temp_exception_code<=E_exception_code;
		  M_isDelay<=E_isDelay;
		  M_exception_DMOV<=E_exception_DMOV;
		  if(E_Tnew!=0) begin
		      M_Tnew<=E_Tnew-1;
		  end
		  else begin
		      M_Tnew<=0;
		  end
	 end
end

endmodule
