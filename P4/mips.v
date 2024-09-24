`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:31:23 11/01/2023 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	 wire [2:0] PCSrc;
	 wire [31:0] pc;
	 wire [31:0] immediate_32;
	 wire [25:0] immediate_26;
	 wire [31:0] Instr;
	 wire [5:0] opcode;
	 wire [5:0] funct;
	 wire [4:0] Instr25_21;
	 wire [4:0] Instr20_16;
	 wire [4:0] Instr15_11;
	 wire [15:0] immediate_16;
	 wire [4:0] A3;
	 wire RegWrite;
	 wire [2:0] MemtoReg;
	 wire MemWrite;
	 wire [2:0] ALUOp;
	 wire ALUSrc;
	 wire [2:0] RegDst;
	 wire ExtOp;
	 wire [2:0] DMOp;
	 wire zero;
	 wire [31:0] RD1;
	 wire [31:0] RD2;
	 wire [31:0] SrcB;
	 wire [31:0] ALUResult;
	 wire [31:0] WD;
	 wire [31:0] DMreaddata;
	 assign A3 = (RegDst==0)? Instr20_16:
	                        (RegDst==1)? Instr15_11:
									(RegDst==2)? 5'b11111:
									0;
	assign SrcB = (ALUSrc==0)? RD2:
	                           (ALUSrc==1)? immediate_32:
										0;
	assign WD = (MemtoReg==0)? ALUResult:
									(MemtoReg==1)? DMreaddata:
									(MemtoReg==2)? pc+4:
									0;//when add instructions,pay attention to wire's bits.
PC PC (
    .clk(clk), 
    .reset(reset), 
    .PCSrc(PCSrc), 
    .immediate_32(immediate_32), 
    .immediate_26(immediate_26), 
	 .ra(RD1),
    .pc_out(pc)
    );
	 
IM IM (
    .PC(pc), 
    .Instr(Instr)
    );
	 
Instr_split Instr_split (
    .Instr(Instr), 
    .opcode(opcode), 
    .funct(funct), 
    .Instr25_21(Instr25_21), 
    .Instr20_16(Instr20_16), 
    .Instr15_11(Instr15_11), 
    .immediate_16(immediate_16), 
    .Instr25_0(immediate_26)
    );
	 
GRF GRF (
    .A1(Instr25_21), 
    .A2(Instr20_16), 
    .A3(A3), 
    .WD(WD), 
    .clk(clk), 
    .reset(reset), 
    .WE(RegWrite), 
    .PC(pc), 
    .RD1(RD1), 
    .RD2(RD2)
    );
	 
ALU ALU (
    .SrcA(RD1), 
    .SrcB(SrcB), 
    .ALUOp(ALUOp), 
    .zero(zero), 
    .ALUResult(ALUResult)
    );
	 
EXT EXT (
    .immediate_16(immediate_16), 
    .ExtOp(ExtOp), 
    .immediate_32(immediate_32)
    );
	 
DM DM (
    .address(ALUResult), 
    .writedata(RD2), 
    .clk(clk), 
    .WE(MemWrite), 
    .reset(reset), 
    .DMOp(DMOp), 
    .PC(pc), 
    .readdata(DMreaddata)
    );
	 
control control (
    .opcode(opcode), 
    .funct(funct), 
    .zero(zero), 
    .MemtoReg(MemtoReg), 
    .MemWrite(MemWrite), 
    .ALUOp(ALUOp), 
    .ALUSrc(ALUSrc), 
    .RegDst(RegDst), 
    .RegWrite(RegWrite), 
    .ExtOp(ExtOp), 
    .PCSrc(PCSrc), 
    .DMOp(DMOp)
    );

endmodule
