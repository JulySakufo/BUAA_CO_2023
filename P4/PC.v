`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:01:06 11/02/2023 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input clk,
    input reset,
    input [2:0] PCSrc,
    input [31:0] immediate_32,
    input [25:0] immediate_26,
	 input [31:0] ra,
    output [31:0] pc_out
    );
reg [31:0] pc;
wire [31:0] beq = immediate_32<<2;
wire [31:0] pc_add_4 = pc_out + 4;
wire [31:0] pc_add_4_offset = pc_add_4 + beq;
wire [31:0] pc31_28_instr_0 = {pc[31:28],immediate_26,2'b0};
assign pc_out = pc;
always@(posedge clk) begin
    if(reset==1) begin
	     pc<=32'h3000;
	 end
	 else begin
	     if(PCSrc==3'b0) begin
		      pc <= pc_add_4;
		  end
		  else if(PCSrc==3'b1) begin
		      pc<=pc_add_4_offset;
		  end
		  else if(PCSrc==3'b10) begin
		      pc<=pc31_28_instr_0;
		  end
		  else if(PCSrc==3'b11) begin
		      pc<=ra;
		  end
	 end
end
endmodule