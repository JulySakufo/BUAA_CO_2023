`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:18:58 11/08/2023 
// Design Name: 
// Module Name:    MW_reg 
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
module MW_reg(
    input clk,
    input reset,
	 input [31:0] M_ALUResult,
    input [31:0] M_DMRD,
	 input [31:0] M_PC,
	 input [31:0] M_Instr,
	 input [4:0] M_A3,
	 input [1:0] M_Tnew,
	 input [31:0] M_HI,
	 input [31:0] M_LO,
	 input [31:0] M_CP0_out,
	 input Req,
	 output reg [31:0] W_ALUResult,
    output reg [31:0] W_DMRD,
	 output reg [4:0] W_A3,
	 output reg [31:0] W_PC,
	 output reg [31:0] W_Instr,
	 output reg [1:0] W_Tnew,
	 output reg [31:0] W_HI,
	 output reg [31:0] W_LO,
	 output reg [31:0] W_CP0_out
    );
always@(posedge clk) begin
    if(reset|Req) begin
	     W_ALUResult<=0;
		  W_DMRD<=0;
		  W_A3<=0;
		  W_PC<=0;
		  W_Instr<=0;
		  W_Tnew<=0;
		  W_HI<=0;
		  W_LO<=0;
		  W_CP0_out<=0;
	 end
	 else begin
	     W_ALUResult<=M_ALUResult;
		  W_DMRD<=M_DMRD;
		  W_A3<=M_A3;
		  W_PC<=M_PC;
		  W_Instr<=M_Instr;
		  W_HI<=M_HI;
		  W_LO<=M_LO;
		  W_CP0_out<=M_CP0_out;
		  if(M_Tnew!=0) begin
		      W_Tnew<=M_Tnew-1;
		  end
		  else begin
		      W_Tnew<=0;
		  end
	 end
end

endmodule
