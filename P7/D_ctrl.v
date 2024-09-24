`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:31:01 11/09/2023 
// Design Name: 
// Module Name:    D_ctrl 
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
module D_ctrl( //D's control, its responsibility is to control extop and pcsrc and regdst, it's d level's signal
    input [31:0] D_Instr,
	 input [31:0] D_forward_RD1,
	 input [31:0] D_forward_RD2,
	 output [4:0] D_A3,
    output [2:0] RegDst,
    output ExtOp,
    output [2:0] PCSrc,
	 output [1:0] D_Tuse_rs,
	 output [1:0] D_Tuse_rt,
	 output HILO_operation,
	 output D_exception_RI,
	 output D_exception_syscall,
	 output D_isDelay_operation,
	 output D_eret
    );
	 wire [5:0] opcode = D_Instr[31:26];
	 wire [5:0] funct = D_Instr[5:0];
	 wire D_RegWrite;
	 
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
wire nop;
wire mfc0;
wire mtc0;
wire eret;
wire syscall;
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
assign zero = (D_forward_RD1==D_forward_RD2)? 1:0;//whether RD1==RD2
assign bne = (opcode==`BNE)? 1:0;
assign one = (D_forward_RD1!=D_forward_RD2)? 1:0;//whether RD1!=RD2
assign jal = (opcode==`JAL)? 1:0;
assign jr = (opcode==`R_TYPE&&funct==`JR_FUNCT)? 1:0;
//assign j = (opcode==`J)? 1:0;
assign nop = (opcode==`R_TYPE&&funct==`NOP_FUNCT)? 1:0;
assign mfc0 = (opcode==6'b010000&&D_Instr[25:21]==5'b00000)? 1:0;
assign mtc0 = (opcode==6'b010000&&D_Instr[25:21]==5'b00100)? 1:0;
assign eret = (D_Instr==32'h4200_0018)? 1:0;
assign syscall = (opcode==`R_TYPE&&funct==`SYSCALL_FUNCT)? 1:0;
//generate signals
assign D_RegWrite = (add|sub|ori|lw|lui|jal|_and|_or|slt|sltu|addi|andi|mfhi|mflo|lh|lb|mfc0);
assign PCSrc = ((beq==1&&zero==1)|(bne==1&&one==1))? 3'b1:
										((jal)==1)? 3'b10:
										(jr==1)? 3'b11:
										(eret==1)? 3'b100:
										0;
assign ExtOp = (beq|lw|sw|bne|addi|lh|lb|sh|sb);//signed immediate
assign RegDst = ((add|sub|_and|_or|slt|sltu|mfhi|mflo)==1)? 3'b1:
											(jal==1)? 3'b10:
											0;
											
assign D_A3 = (D_RegWrite==0)? 5'b0:
                           (RegDst==0)? D_Instr[20:16]:
	                        (RegDst==1)? D_Instr[15:11]:
									(RegDst==2)? 5'b11111:
									0;
									
assign HILO_operation = (mult|multu|div|divu|mfhi|mflo|mthi|mtlo);

//calculate Tuse,it's a constant once instruction is ensured.
assign D_Tuse_rs = (add|sub|ori|lw|sw|_and|_or|slt|sltu|addi|andi|mult|multu|div|divu|mthi|mtlo|lh|lb|sh|sb)? 1:
											(beq|jr|bne)?0:
											2;//if not jump instruction,and we needn't rs ,make it longer to ensure Tuse>Tnew
assign D_Tuse_rt = (add|sub|_and|_or|slt|sltu|mult|multu|div|divu)? 1:
											(beq|jr|bne)? 0:
											2;								

assign D_exception_RI = !(nop|add|sub|_and|_or|slt|sltu|lui|addi|andi|ori|lw|lh|lb|sw|sh|sb|mult|multu|div|divu|mfhi|mflo|mthi|mtlo|beq|bne|jr|jal|mfc0|mtc0|eret|syscall);
assign D_exception_syscall = syscall;
assign D_isDelay_operation = (beq|bne|jal|jr);
assign D_eret = eret;
endmodule
