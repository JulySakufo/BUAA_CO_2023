`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:23:09 11/02/2023 
// Design Name: 
// Module Name:    control 
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
`define ADD_FUNCT 6'b100000
`define SUB_FUNCT 6'b100010
`define ORI 6'b001101
`define LW 6'b100011
`define SW 6'b101011
`define BEQ 6'b000100
`define LUI 6'b001111
`define JAL 6'b000011
`define JR_FUNCT 6'b001000
`define NOP_FUNCT 6'b000000
`define R_TYPE 6'b000000
module control(
    input [5:0] opcode,
    input [5:0] funct,
    input zero,
    output [2:0] MemtoReg,
    output MemWrite,
    output [2:0] ALUOp,
    output ALUSrc,
    output [2:0] RegDst,
    output RegWrite,
    output ExtOp,
    output [2:0] PCSrc,
    output [2:0] DMOp
    );
wire add;
wire sub;
wire ori;
wire lw;
wire sw;
wire beq;
wire lui;
wire jal;
wire jr;
wire r_type;
assign add = (opcode==`R_TYPE&&funct==`ADD_FUNCT)? 1:0;
assign sub = (opcode==`R_TYPE&&funct==`SUB_FUNCT)? 1:0;
assign ori = (opcode==`ORI)? 1:0;
assign lw = (opcode==	`LW)? 1:0;
assign sw = (opcode==`SW)? 1:0;
assign beq = (opcode==`BEQ)? 1:0;
assign lui = (opcode==`LUI)? 1:0;
assign jal = (opcode==`JAL)? 1:0;
assign jr = (opcode==`R_TYPE&&funct==`JR_FUNCT)? 1:0;

//output signal;
assign MemtoReg = (lw==1)? 3'b1:
													(jal==1)? 3'b10:
													0;
assign MemWrite = sw;
assign ALUOp = (ori==1)? 3'b1:
                                ((add|lw|sw)==1)? 3'b10:
										  (lui==1)? 3'b11:
										  ((sub|beq)==1)? 3'b110:
										  0;
assign ALUSrc = (ori|lui|lw|sw);
assign RegDst = ((add|sub)==1)? 3'b1:
											(jal==1)? 3'b10:
											0;
assign RegWrite = (add|sub|ori|lw|lui|jal);
assign ExtOp = (beq|lw|sw);//signed immediate
assign PCSrc = (beq==1&&zero==1)? 3'b1:
										(jal==1)? 3'b10:
										(jr==1)? 3'b11:
										0;
assign DMOp = ((lw|sw)==1)? 1:0;
endmodule
