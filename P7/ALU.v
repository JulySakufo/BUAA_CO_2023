`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:49:40 11/23/2023 
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
`define AND 3'b000
`define OR 3'b001
`define ADD 3'b010
`define LUI 3'b011
`define SLT 3'b100
`define SLTU 3'b101
`define SUB 3'b110

module ALU(
    input ALUArithmetic,
	 input ALUDM,
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [2:0] ALUOp,
    output [31:0] ALUResult,
	 output E_exception_AriOV,
	 output E_exception_DMOV
    );
	 integer i;
	 
	 wire [31:0] c;
	 wire [32:0] temp_A = {SrcA[31],SrcA};
	 wire [32:0] temp_B = {SrcB[31],SrcB};
	 wire [32:0] temp_result_add = temp_A + temp_B;
	 wire [32:0] temp_result_sub = temp_A - temp_B;
assign ALUResult = (ALUOp==`AND)? (SrcA&SrcB):
                   (ALUOp==`OR)? (SrcA|SrcB):
                   (ALUOp==`ADD)?(SrcA+SrcB):
                   (ALUOp==`SUB)?(SrcA-SrcB):
                   (ALUOp==`LUI)?(SrcA|(SrcB<<16)):
						 ((ALUOp==`SLT)&& ($signed(SrcA)<$signed(SrcB)))? 1:
						 ((ALUOp==`SLTU)&& (SrcA<SrcB))? 1:
                   0;
assign E_exception_AriOV = (ALUArithmetic&&ALUOp==`ADD&&(temp_result_add[32]!=temp_result_add[31]))||  //add,addi
																			(ALUArithmetic&&ALUOp==`SUB&&(temp_result_sub[32]!=temp_result_sub[31]));  //sub
assign E_exception_DMOV = (ALUDM&&((temp_result_add[32]!=temp_result_add[31])));//(lw|lh|lb|sw|sh|sb)(only add not sub)
endmodule
