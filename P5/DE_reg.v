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
    input [31:0] RD1_in,
    input [31:0] RD2_in,
    input [31:0] immediate_32_in,
	 input [31:0] D_PC,
	 input [31:0] D_Instr,
	 input [4:0] D_A3,
	 input stall,
    output reg [31:0] RD1_out,
    output reg [31:0] RD2_out,
    output reg [31:0] immediate_32_out,
	 output reg [31:0] E_PC,
	 output reg [31:0] E_Instr,
	 output reg [4:0] E_A3
    );
always@(posedge clk) begin
    if((reset|stall)==1) begin 
	     RD1_out<=0;
		  RD2_out<=0;
		  immediate_32_out<=0;
		  E_PC<=0;
		  E_Instr<=0;
		  E_A3<=0;
	 end
	 else begin
	     RD1_out<=RD1_in;
		  RD2_out<=RD2_in;
		  immediate_32_out<=immediate_32_in;
		  E_PC<=D_PC;
		  E_Instr<=D_Instr;
		  E_A3<=D_A3;
	 end
end

endmodule
