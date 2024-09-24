`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:32:11 11/09/2023 
// Design Name: 
// Module Name:    M_ctrl 
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
module M_ctrl(
    input [31:0] M_Instr,
	 input [31:0] M_PC,
	 input [31:0]M_ALUResult,
	 input [31:0] M_HI,
	 input [31:0] M_LO,
	 output [31:0] M_WD,
	 output [3:0] m_data_byteen,
	 output [2:0] BEOp,
	 output M_mtc0,
	 output M_eret
    );
	 wire [5:0] opcode =  M_Instr [31:26];
	 wire [5:0] funct = M_Instr [5:0];
    wire [2:0] MemtoReg;
	 
wire add;
//wire addu;
wire sub;
wire _and;
wire _or;
wire slt;
wire sltu;
wire mult;
wire multu;
wire div;
wire divu;
wire mfhi;
wire mflo;
wire mthi;
wire mtlo;
wire ori;
wire addi;
wire andi;
wire lui;
wire lw;
wire lh;
wire lb;
wire sw;
wire sh;
wire sb;
wire jal;
wire jr;
//wire j;
wire beq;
wire zero;
wire bne;
wire one;
wire mfc0;
wire mtc0;
wire eret;
///////////////////////////
assign add = (opcode==`R_TYPE&&funct==`ADD_FUNCT)? 1:0;
//assign addu = (opcode==`R_TYPE&&funct==`ADDU_FUNCT)? 1:0;
assign sub = (opcode==`R_TYPE&&funct==`SUB_FUNCT)? 1:0;
assign _and = (opcode==`R_TYPE&&funct==`AND_FUNCT)? 1:0;
assign _or = (opcode==`R_TYPE&&funct==`OR_FUNCT)? 1:0;
assign slt = (opcode==`R_TYPE&&funct==`SLT_FUNCT)? 1:0;
assign sltu = (opcode==`R_TYPE&&funct==`SLTU_FUNCT)? 1:0;
assign mult = (opcode==`R_TYPE&&funct==`MULT_FUNCT)? 1:0;
assign multu = (opcode==`R_TYPE&&funct==`MULTU_FUNCT)? 1:0;
assign div = (opcode==`R_TYPE&&funct==`DIV_FUNCT)? 1:0;
assign divu = (opcode==`R_TYPE&&funct==`DIVU_FUNCT)? 1:0;
assign mfhi = (opcode==`R_TYPE&&funct==`MFHI_FUNCT)? 1:0;
assign mflo = (opcode==`R_TYPE&&funct==`MFLO_FUNCT)? 1:0;
assign mthi = (opcode==`R_TYPE&&funct==`MTHI_FUNCT)? 1:0;
assign mtlo = (opcode==`R_TYPE&&funct==`MTLO_FUNCT)? 1:0;
assign ori = (opcode==`ORI)? 1:0;
assign addi = (opcode==`ADDI)? 1:0;
assign andi = (opcode==`ANDI)? 1:0;
assign lui = (opcode==`LUI)? 1:0;
assign lw = (opcode==	`LW)? 1:0;
assign lh = (opcode==`LH)? 1:0;
assign lb = (opcode==`LB)? 1:0;
assign sw = (opcode==`SW)? 1:0;
assign sh = (opcode==`SH)? 1:0;
assign sb = (opcode==`SB)? 1:0;
assign beq = (opcode==`BEQ)? 1:0;
assign bne = (opcode==`BNE)? 1:0;
assign jal = (opcode==`JAL)? 1:0;
assign jr = (opcode==`R_TYPE&&funct==`JR_FUNCT)? 1:0;
assign mfc0 = (opcode==6'b010000&&M_Instr[25:21]==5'b00000)? 1:0;
assign mtc0 = (opcode==6'b010000&&M_Instr[25:21]==5'b00100)? 1:0;
assign eret = (M_Instr==32'h4200_0018)? 1:0;
//generate signals

assign MemtoReg = ((lw|lh|lb|mfc0)==1)? 3'b1:
													(jal==1)? 3'b10:
													(mfhi==1)? 3'b11:
													(mflo==1)? 3'b100:
													0;
													
assign M_WD = (MemtoReg==0)? M_ALUResult:
										(MemtoReg==2)? M_PC+8:
										(MemtoReg==3)? M_HI:
										(MemtoReg==4)? M_LO:
										0;
										
assign m_data_byteen =  (sw==1)? 4'b1111:
																  (sh==1&&M_ALUResult[1]==0)? 4'b0011:
																  (sh==1&&M_ALUResult[1]==1)? 4'b1100:
																  (sb==1&&M_ALUResult[1:0]==0)? 4'b0001:
																  (sb==1&&M_ALUResult[1:0]==1)? 4'b0010:
																  (sb==1&&M_ALUResult[1:0]==2)? 4'b0100:
																  (sb==1&&M_ALUResult[1:0]==3)? 4'b1000:
																  0;
																  
assign BEOp = (lw==1)? 3'b000:
										(lh==1)? 3'b011:
										(lb==1)? 3'b001:
										3'b111;
assign M_mtc0 = mtc0;
assign M_eret = eret;
endmodule
