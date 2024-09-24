`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:47 11/09/2023 
// Design Name: 
// Module Name:    W_ctrl 
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
`include "constant.v"
module W_ctrl(
    input [31:0] W_Instr,
	 input [31:0] W_ALUResult,
	 input [31:0] W_DMRD,
	 input [31:0] W_HI,
	 input [31:0] W_LO,
	 input [31:0] W_PC,
    output [31:0] W_WD
    );
	 wire [5:0] opcode = W_Instr[31:26];
	 wire [5:0] funct = W_Instr[5:0];
	 wire [2:0] MemtoReg;
wire add;
wire addu;
wire sub;
wire ori;
wire lw;
wire lh;
wire lb;
wire sw;
wire sh;
wire sb;
wire beq;
wire lui;
wire jal;
wire jr;
wire r_type;
wire _and;
wire _or;
wire slt;
wire sltu;
wire addi;
wire andi;
wire mult;
wire multu;
wire div;
wire divu;
wire mfhi;
wire mflo;
wire mthi;
wire mtlo;
assign add = (opcode==`R_TYPE&&funct==`ADD_FUNCT)? 1:0;
assign addu = (opcode==`R_TYPE&&funct==`ADDU_FUNCT)? 1:0;
assign sub = (opcode==`R_TYPE&&funct==`SUB_FUNCT)? 1:0;
assign ori = (opcode==`ORI)? 1:0;
assign lw = (opcode==	`LW)? 1:0;
assign lh = (opcode==`LH)? 1:0;
assign lb = (opcode==`LB)? 1:0;
assign sw = (opcode==`SW)? 1:0;
assign sh = (opcode==`SH)? 1:0;
assign sb = (opcode==`SB)? 1:0;
assign beq = (opcode==`BEQ)? 1:0;
assign lui = (opcode==`LUI)? 1:0;
assign jal = (opcode==`JAL)? 1:0;
assign jr = (opcode==`R_TYPE&&funct==`JR_FUNCT)? 1:0;
assign _and = (opcode==`R_TYPE&&funct==`AND_FUNCT)? 1:0;
assign _or = (opcode==`R_TYPE&&funct==`OR_FUNCT)? 1:0;
assign slt = (opcode==`R_TYPE&&funct==`SLT_FUNCT)? 1:0;
assign sltu = (opcode==`R_TYPE&&funct==`SLTU_FUNCT)? 1:0;//wrong
assign addi = (opcode==`ADDI)? 1:0;
assign andi = (opcode==`ANDI)? 1:0;
assign mult = (opcode==`R_TYPE&&funct==`MULT_FUNCT)? 1:0;
assign multu = (opcode==`R_TYPE&&funct==`MULTU_FUNCT)? 1:0;
assign div = (opcode==`R_TYPE&&funct==`DIV_FUNCT)? 1:0;
assign divu = (opcode==`R_TYPE&&funct==`DIVU_FUNCT)? 1:0;
assign mfhi = (opcode==`R_TYPE&&funct==`MFHI_FUNCT)? 1:0;
assign mflo = (opcode==`R_TYPE&&funct==`MFLO_FUNCT)? 1:0;
assign mthi = (opcode==`R_TYPE&&funct==`MTHI_FUNCT)? 1:0;
assign mtlo = (opcode==`R_TYPE&&funct==`MTLO_FUNCT)? 1:0;
//generate signals
assign MemtoReg = ((lw|lh|lb)==1)? 3'b001:
													(jal==1)? 3'b010:
													(mfhi==1)? 3'b011:
													(mflo==1)? 3'b100:
													0;
assign W_WD = (MemtoReg==0)? W_ALUResult:
										(MemtoReg==1)? W_DMRD:
										(MemtoReg==2)? W_PC+8:
										(MemtoReg==3)? W_HI:
										(MemtoReg==4)? W_LO:
										0;
endmodule
