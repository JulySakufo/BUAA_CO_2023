`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:19:34 11/01/2023 
// Design Name: 
// Module Name:    ALU 
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
`define AND 3'b0
`define OR 3'b1
`define ADD 3'b10
`define LUI 3'b11
`define SUB 3'b110
module ALU(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [2:0] ALUOp,
    output zero,
    output [31:0] ALUResult
    );
	 integer i;
	 wire [31:0] c;
assign ALUResult = (ALUOp==`AND)? (SrcA&SrcB):
                   (ALUOp==`OR)? (SrcA|SrcB):
                   (ALUOp==`ADD)?(SrcA+SrcB):
                   (ALUOp==`SUB)?(SrcA-SrcB):
                   (ALUOp==`LUI)?(SrcA|(SrcB<<16)):
                   0;
assign zero = ((SrcA-SrcB)==0)?1:0;
endmodule
