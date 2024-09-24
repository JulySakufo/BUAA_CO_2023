`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:09:44 11/08/2023 
// Design Name: 
// Module Name:    DE_reg 
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
module DE_reg(
    input clk,
    input reset,
    input [31:0] D_forward_RD1,
    input [31:0] D_forward_RD2,
    input [31:0] D_immediate_32,
	 input [31:0] D_PC,
	 input [31:0] D_Instr,
	 input [4:0] D_A3,
	 input stall,
    output reg [31:0] E_RD1,
    output reg [31:0] E_RD2,
    output reg [31:0] E_immediate_32,
	 output reg [31:0] E_PC,
	 output reg [31:0] E_Instr,
	 output reg [4:0] E_A3
    );
always@(posedge clk) begin
    if((reset|stall)==1) begin 
	     E_RD1<=0;
		  E_RD2<=0;
		  E_immediate_32<=0;
		  E_PC<=0;
		  E_Instr<=0;
		  E_A3<=0;
	 end
	 else begin
	     E_RD1<=D_forward_RD1;
		  E_RD2<=D_forward_RD2;
		  E_immediate_32<=D_immediate_32;
		  E_PC<=D_PC;
		  E_Instr<=D_Instr;
		  E_A3<=D_A3;
	 end
end

endmodule
