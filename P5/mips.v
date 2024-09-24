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
    wire [3 :0] m_data_byteen;
	 
	 wire [2:0] PCSrc;
	 wire stall;
	 
	 wire MemWrite;
	 wire [2:0] ALUOp;
	 wire ALUSrc;
	 wire [2:0] RegDst;
	 wire ExtOp;
	 wire [2:0] DMOp;
	 wire [31:0] SrcB;
	 wire [2:0]BEOp;
	 wire HILO_operation;
	 wire Busy;
	 wire Start;
	 wire [3:0] Op;
	 
	 wire [31:0] F_PC;
	 wire [31:0] F_Instr;
	 
	  wire [31:0] D_PC;
	 wire [31:0] D_Instr;
	 wire [15:0] D_immediate_16 = D_Instr[15:0];
	 wire [25:0] D_immediate_26 = D_Instr[25:0];
	 wire [31:0] D_immediate_32;
	 wire [4:0] D_A1 = D_Instr[25:21];
	 wire [4:0] D_A2 = D_Instr[20:16];
	 wire [4:0] D_A3;
	 wire [31:0] D_RD1;
	 wire [31:0] D_RD2;
	 wire [31:0] D_forward_RD1;
	 wire [31:0] D_forward_RD2;
	 wire [1:0] D_Tuse_rs;
	 wire [1:0] D_Tuse_rt;
	 
	 wire [31:0] E_PC;
	 wire [31:0] E_Instr;
	 wire [31:0] E_immediate_32;
	 wire [31:0] E_ALUResult;
	 wire [4:0] E_A1 = E_Instr[25:21];
	 wire [4:0] E_A2 = E_Instr[20:16];
	 wire [4:0] E_A3;
	 wire [31:0] E_RD1;
	 wire [31:0] E_RD2;
	 wire [31:0] E_forward_RD1;
	 wire [31:0] E_forward_RD2;
	 wire [1:0] E_Tnew;
	 wire [31:0] E_WD;
	 wire [31:0] E_HI;
	 wire [31:0] E_LO;
	 wire E_Start;
	 
	 wire [31:0] M_PC;
	 wire [31:0] M_Instr;
	 wire [31:0] M_ALUResult;
	 wire [31:0] M_DMRD;
	 wire [4:0] M_A1=M_Instr[25:21];
	 wire [4:0] M_A2=M_Instr[20:16];
	 wire [4:0] M_A3;
	 wire [31:0] M_RD2;
	 wire [31:0] M_forward_RD2;
	 wire [1:0] M_Tnew;
	 wire [31:0] M_WD;
	 wire [31:0] M_HI;
	 wire [31:0] M_LO;
	 
	 wire [31:0] W_PC;
	 wire [31:0] W_Instr;
	 wire [31:0] W_DMRD;
	 wire [31:0] W_ALUResult;
	 wire [4:0] W_A3;
	 wire [1:0] W_Tnew;
	 wire [31:0] W_WD;
	 wire [31:0] W_HI;
	 wire [31:0] W_LO;
	 
	 
	assign SrcB = (ALUSrc==0)? E_forward_RD2:
	                           (ALUSrc==1)? E_immediate_32:
										0;
    assign D_forward_RD1 = (D_A1==0)? 0:
																		((D_A1==E_A3)&&(E_Tnew==0))? E_WD:
																		((D_A1==M_A3)&&(M_Tnew==0))? M_WD:
																		D_RD1;
    assign D_forward_RD2 = (D_A2==0)? 0:
																		((D_A2==E_A3)&&(E_Tnew==0))? E_WD:
																		((D_A2==M_A3)&&(M_Tnew==0))? M_WD:
																		D_RD2;
																		
	assign E_forward_RD1 = (E_A1==0)? 0:
																	(E_A1==M_A3)&&(M_Tnew==0)? M_WD:
																	(E_A1==W_A3)? W_WD://W_Tnew===0;
																	E_RD1;
																	
	assign E_forward_RD2 = (E_A2==0)? 0:
																	(E_A2==M_A3)&&(M_Tnew==0)? M_WD:
																	(E_A2==W_A3)? W_WD:
																	E_RD2;
	assign M_forward_RD2 = (M_A2==0)? 0:
																		(M_A2==W_A3)? W_WD:
																		M_RD2;
	

PC PC (
    .clk(clk), 
    .reset(reset), 
    .PCSrc(PCSrc), 
	 .stall(stall),
    .immediate_32(D_immediate_32), 
    .immediate_26(D_immediate_26), 
	 .ra(D_forward_RD1),
    .pc_out(F_PC)
    );
	 
	 IM IM (
    .i_inst_addr(F_PC), 
    .i_inst_rdata(F_Instr)
    );



	 //////////////////////////////////////////////////////////////////    F level  and we introduce  FD_reg
	 FD_reg FD_reg (
    .clk(clk), 
    .reset(reset), 
	 .stall(stall),
	 .F_PC(F_PC),
	 .F_Instr(F_Instr),
	 .D_PC(D_PC),//not this instruction's pc, but next instruction's pc
	 .D_Instr(D_Instr)
    );

	 
	 
GRF GRF (
    .A1(D_A1), 
    .A2(D_A2), 
    .A3(W_A3), 
    .WD(W_WD), 
    .clk(clk), 
    .reset(reset), 
	 .W_PC(W_PC),
    .RD1(D_RD1), 
    .RD2(D_RD2)
    );
	 
	 EXT EXT (
    .immediate_16(D_immediate_16), 
    .ExtOp(ExtOp), 
    .immediate_32(D_immediate_32)
    );
	 
	 D_ctrl D_ctrl (     //D level's control signal
    .D_Instr(D_Instr),
    .D_forward_RD1(D_forward_RD1), 
    .D_forward_RD2(D_forward_RD2), 
	 .D_A3(D_A3),
    .RegDst(RegDst), 
    .ExtOp(ExtOp), 
    .PCSrc(PCSrc),
	 .D_Tuse_rs(D_Tuse_rs),
	 .D_Tuse_rt(D_Tuse_rt),
	 .HILO_operation(HILO_operation)
    );

	 /////////////////////////////////////////////////////////////////////////////// D level and we introduce DE_reg
	 DE_reg DE_reg (
    .clk(clk), 
    .reset(reset), 
	 .stall(stall),
    .RD1_in(D_forward_RD1), 
    .RD2_in(D_forward_RD2), 
    .immediate_32_in(D_immediate_32), 
	 .D_PC(D_PC),
	 .D_Instr(D_Instr), //according to this to generate control signal;
	 .D_A3(D_A3),
    .RD1_out(E_RD1), 
    .RD2_out(E_RD2), 
    .immediate_32_out(E_immediate_32),
	 .E_PC(E_PC),
	 .E_Instr(E_Instr),
	 .E_A3(E_A3)
    );

	 
ALU ALU (
    .SrcA(E_forward_RD1), 
    .SrcB(SrcB), 
    .ALUOp(ALUOp), 
    .ALUResult(E_ALUResult)
    );
	 
	 Mult_Div Mult_Div (
    .clk(clk), 
    .reset(reset), 
    .E_RD1(E_forward_RD1), 
    .E_RD2(E_forward_RD2), 
    .Op(Op), 
    .HI(E_HI), 
    .LO(E_LO), 
    .E_Start(E_Start), 
    .Busy(Busy)
    );
	 
	 E_ctrl E_ctrl (    //E level's signal control
    .E_Instr(E_Instr), 
	 .E_PC(E_PC),
	 .E_HI(E_HI),
	 .E_LO(E_LO),
    .ALUOp(ALUOp), 
    .ALUSrc(ALUSrc),
	 .E_Tnew(E_Tnew),
	 .E_WD(E_WD),
	 .Op(Op),
	 .E_Start(E_Start)
    );
////////////////////////////////////////////////////////////////////////// E level and we introduce EM_reg
	 
	 EM_reg EM_reg (
    .clk(clk), 
    .reset(reset), 
	 .E_PC(E_PC),
	 .E_Instr(E_Instr),
	 .E_RD2(E_forward_RD2),
	 .E_A3(E_A3),
    .ALUResult_in(E_ALUResult), 
	 .E_Tnew(E_Tnew),
	 .E_HI(E_HI),
	 .E_LO(E_LO),
    .ALUResult_out(M_ALUResult),
	 .M_PC(M_PC),
	 .M_Instr(M_Instr),
	 .M_RD2(M_RD2),
	 .M_A3(M_A3),
	 .M_Tnew(M_Tnew),
	 .M_HI(M_HI),
	 .M_LO(M_LO)
    );
	 
	 
	 M_ctrl M_ctrl(
    .M_Instr(M_Instr), 
	 .M_ALUResult(M_ALUResult),
	 .M_PC(M_PC),
	 .M_HI(M_HI),
	 .M_LO(M_LO),
    .m_data_byteen(m_data_byteen),
	 .M_WD(M_WD),
	 .BEOp(BEOp)
    );
	 
	 /*BE BE(
    .A(M_ALUResult[1:0]), 
    .Din(m_data_rdata), 
    .Op(BEOp), 
    .Dout(M_DMRD)
    );*/

DM DM (
    .clk(clk), 
    .reset(reset), 
    .PC(M_PC), 
	 .Op(BEOp),
    .M_ALUResult(M_ALUResult), 
    .M_forward_RD2(M_forward_RD2), 
    .m_data_byteen(m_data_byteen), 
    .m_data_rdata(M_DMRD)
    );

	 ////////////////////////////////////////////////////////////////////// M level
	 MW_reg MW_reg (
    .clk(clk), 
    .reset(reset), 
    .M_ALUResult(M_ALUResult), 
    .M_DMRD(M_DMRD), 
    .M_PC(M_PC), 
    .M_Instr(M_Instr), 
    .M_A3(M_A3), 
	 .M_Tnew(M_Tnew),
	 .M_HI(M_HI),
	 .M_LO(M_LO),
    .W_ALUResult(W_ALUResult), 
    .W_DMRD(W_DMRD), 
    .W_A3(W_A3), 
    .W_PC(W_PC),
	 .W_Instr(W_Instr),
	 .W_Tnew(W_Tnew),
	 .W_HI(W_HI),
	 .W_LO(W_LO)
    );

    W_ctrl W_ctrl(
    .W_Instr(W_Instr), 
	 .W_ALUResult(W_ALUResult),
	 .W_DMRD(W_DMRD),
	 .W_HI(W_HI),
	 .W_LO(W_LO),
	 .W_PC(W_PC),
    .W_WD(W_WD)//generate writedata
    );
	 
	 ////////////////////////////////////////////////////////////////////// W level
    Stall Stall (
    .D_Tuse_rs(D_Tuse_rs), 
    .D_Tuse_rt(D_Tuse_rt), 
    .E_Tnew(E_Tnew), 
    .M_Tnew(M_Tnew), 
    .D_A1(D_A1), 
    .D_A2(D_A2), 
    .E_A3(E_A3), 
    .M_A3(M_A3), 
	 .HILO_operation(HILO_operation),
	 .Busy(Busy),
	 .E_Start(E_Start),
    .stall(stall)
    );

endmodule
