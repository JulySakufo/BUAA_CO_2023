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
	 input [31:0] F_PC,
	 input [31:0] F_Instr,
	 output reg [31:0] D_PC,
	 output reg [31:0] D_Instr
    );
always@(posedge clk) begin
    if(reset==1) begin // clear FD registers
		  D_PC<=0;
		  D_Instr<=0;
	 end
	 else begin
	 if(stall==0) begin //pipeline;
		  D_PC<=F_PC;
		  D_Instr<=F_Instr;
	 end
	 end
end

endmodule
