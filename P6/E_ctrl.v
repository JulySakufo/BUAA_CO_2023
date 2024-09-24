`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:18:52 11/09/2023 
// Design Name: 
// Module Name:    E_ctrl 
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
module E_ctrl(
    input [31:0] E_Instr,
	 input [31:0] E_PC,
    output [2:0] ALUOp,
    output ALUSrc,
	 output [1:0] E_Tnew,
	 output [31:0] E_WD,
	 output start,
	 output [3:0] MDOp
    );
	 wire [5:0] opcode = E_Instr[31:26];
	 wire [5:0] funct = E_Instr[5:0];
	 
wire add;
wire addu;
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
wire j;
wire beq;
wire zero;
wire bne;
wire one;
///////////////////////////
assign add = (opcode==`R_TYPE&&funct==`ADD_FUNCT)? 1:0;
assign addu = (opcode==`R_TYPE&&funct==`ADDU_FUNCT)? 1:0;
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
assign j = (opcode==`J)? 1:0;
//generate signals
assign ALUSrc = (ori|lui|lw|sw|addi|andi|lh|lb|sh|sb);
assign ALUOp = ((ori|_or)==1)? 3'b1:
                                ((add|lw|sw|addu|addi|lh|lb|sh|sb)==1)? 3'b10:
										  (lui==1)? 3'b11:
										  ((sub|beq|bne)==1)? 3'b110:
										  ((_and|andi)==1)? 3'b0:
										  (slt==1)? 3'b100:
										  (sltu==1)? 3'b101:
										  0;
assign E_Tnew = (add|sub|ori|lui|addu|_and|_or|slt|sltu|addi|andi|mfhi|mflo)?1://ALU
											(lw|lh|lb)?2://DM
											0;//PC
											
assign MemtoReg = ((lw|lh|lb)==1)? 3'b1:
													(jal==1)? 3'b10:
													(mfhi==1)? 3'b11:
													(mflo==1)? 3'b100:
													0;
													
assign E_WD = (MemtoReg==2)? E_PC+8:
										0;//E level only produces the E_PC
assign start = (mult|multu|div|divu);
assign MDOp = (mult==1)? 4'b0000:
								(multu==1)? 4'b0001:
								(div==1)? 4'b0010:
								(divu==1)? 4'b0011:
								(mfhi==1)? 4'b0100:
								(mflo==1)? 4'b0101:
								(mthi==1)? 4'b0110:
								(mtlo==1)? 4'b0111:
								4'b1111;
endmodule
