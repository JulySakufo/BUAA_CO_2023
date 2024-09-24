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
module mips_CPU(
    input clk,
    input reset,
	 input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
	 input [5:0] HWInt,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr,
	 output [31:0] macroscopic_pc
    );

    assign i_inst_addr = F_PC;
	 
	 assign m_data_addr = M_ALUResult;
	 assign m_inst_addr = M_PC;
	 assign m_data_wdata = (m_data_byteen==4'b1111)? M_forward_RD2:
																	 (m_data_byteen==4'b0011)? M_forward_RD2:
																	 (m_data_byteen==4'b1100)? M_forward_RD2<<16:
																	 (m_data_byteen==4'b0001)? M_forward_RD2:
																	 (m_data_byteen==4'b0010)? M_forward_RD2<<8:
																	 (m_data_byteen==4'b0100)? M_forward_RD2<<16:
																	 (m_data_byteen==4'b1000)? M_forward_RD2<<24:
																	 0;
	 
	 
	 assign w_grf_we = 1;
	 assign w_grf_addr = W_A3;
    assign w_grf_wdata = W_WD;
    assign w_inst_addr = W_PC;	 
	 assign macroscopic_pc = M_PC;
	 
	 wire [2:0] PCSrc;
	 wire stall;
	 wire Req;
	 
	 wire [2:0] ALUOp;
	 wire ALUSrc;
	 wire [2:0] RegDst;	
	 wire ExtOp;
	 wire [31:0] SrcB;
	 wire HILO_operation;
	 wire start;
	 wire [3:0] MDOp;
	 wire Busy;
	 wire [31:0] HI;
	 wire [31:0] LO;
	 wire [2:0] BEOp;
	 wire ALUArithmetic;
	 wire ALUDM;
	wire [31:0] EPC_out;
	wire [31:0] temp_F_PC;
	wire [3:0] temp_m_data_byteen;

	 
	 wire [31:0] F_PC;
	 wire [31:0] F_Instr;
	 wire F_exception_AdEL;
	 wire [4:0] F_exception_code;
	 wire F_isDelay;
	 
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
	 wire D_exception_RI;
	 wire D_exception_syscall;
	 wire [4:0] D_temp_exception_code;
	 wire [4:0] D_exception_code;
	 wire D_isDelay;
	 wire D_isDelay_operation;
	 wire D_eret;
	 
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
	 wire E_exception_AriOV;
	 wire E_exception_DMOV;
	 wire [4:0] E_temp_exception_code;
	 wire [4:0] E_exception_code;
	 wire E_isDelay;
	 wire E_mtc0;
	 
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
	 wire M_exception_AdEL;
	 wire M_exception_AdES;
	 wire [4:0] M_temp_exception_code;
	 wire [4:0] M_exception_code;
	 wire M_mtc0;
	wire M_eret;
	wire M_isDelay;
	wire [31:0] M_CP0_out;
	wire M_exception_DMOV;
	 
	 wire [31:0] W_PC;
	 wire [31:0] W_Instr;
	 wire [31:0] W_DMRD;
	 wire [31:0] W_ALUResult;
	 wire [4:0] W_A3;
	 wire [1:0] W_Tnew;
	 wire [31:0] W_WD;
	 wire [31:0] W_HI;
	 wire [31:0] W_LO;
	 wire [31:0] W_CP0_out;
	 
	 
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
	 .D_PC(D_PC),
	 .Req(Req),
    .immediate_32(D_immediate_32), 
    .immediate_26(D_immediate_26), 
	 .ra(D_forward_RD1),
	 .EPC_out(EPC_out),
    .pc_out(temp_F_PC)
    );
	 
	 assign F_PC = D_eret? EPC_out : temp_F_PC;
	 assign F_Instr = F_exception_AdEL? 32'b0:i_inst_rdata;
	 assign F_exception_AdEL = (|F_PC[1:0])||(F_PC<32'h0000_3000)||(F_PC>32'h0000_6ffc);
	 assign F_exception_code = (F_exception_AdEL)? 4:0;
	 assign F_isDelay = D_isDelay_operation?1:0;//judge the delay when instruction is f
	 //////////////////////////////////////////////////////////////////    F level  and we introduce  FD_reg
	 FD_reg FD_reg (
    .clk(clk), 
    .reset(reset), 
	 .stall(stall),
	 .Req(Req),
	 .F_PC(F_PC),
	 .F_Instr(F_Instr),
	 .F_exception_code(F_exception_code),
	 .F_isDelay(F_isDelay),
	 .D_PC(D_PC),//not this instruction's pc, but next instruction's pc
	 .D_Instr(D_Instr),
	 .D_temp_exception_code(D_temp_exception_code),
	 .D_isDelay(D_isDelay)
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
	 .HILO_operation(HILO_operation),
	 .D_exception_RI(D_exception_RI),
	 .D_exception_syscall(D_exception_syscall),
	 .D_isDelay_operation(D_isDelay_operation),
	 .D_eret(D_eret)
    );

assign D_exception_code = (D_temp_exception_code)? D_temp_exception_code:
																		 (D_exception_RI)? 5'd10:
																		 (D_exception_syscall)? 5'd8:
																		 0;
	 /////////////////////////////////////////////////////////////////////////////// D level and we introduce DE_reg
	 DE_reg DE_reg (
    .clk(clk), 
    .reset(reset), 
	 .stall(stall),
	 .Req(Req),
    .D_forward_RD1(D_forward_RD1), 
    .D_forward_RD2(D_forward_RD2), 
    .D_immediate_32(D_immediate_32), 
	 .D_PC(D_PC),
	 .D_Instr(D_Instr), //according to this to generate control signal;
	 .D_A3(D_A3),
	 .D_exception_code(D_exception_code),
	 .D_isDelay(D_isDelay),
    .E_RD1(E_RD1), 
    .E_RD2(E_RD2), 
    .E_immediate_32(E_immediate_32),
	 .E_PC(E_PC),
	 .E_Instr(E_Instr),
	 .E_A3(E_A3),
	 .E_temp_exception_code(E_temp_exception_code),
	 .E_isDelay(E_isDelay)
    );

	 
ALU ALU (
    .ALUArithmetic(ALUArithmetic),
	 .ALUDM(ALUDM),
    .SrcA(E_forward_RD1), 
    .SrcB(SrcB), 
    .ALUOp(ALUOp), 
    .ALUResult(E_ALUResult),
	 .E_exception_AriOV(E_exception_AriOV),
	 .E_exception_DMOV(E_exception_DMOV)
    );
	 
	 E_ctrl E_ctrl (    //E level's signal control
    .E_Instr(E_Instr), 
	 .E_PC(E_PC),
    .ALUOp(ALUOp), 
    .ALUSrc(ALUSrc),
	 .E_Tnew(E_Tnew),
	 .E_WD(E_WD),
	 .start(start),
	 .MDOp(MDOp),
	 .ALUArithmetic(ALUArithmetic),
	 .ALUDM(ALUDM),
	 .E_mtc0(E_mtc0)
    );
	 
	 MDU MDU (
    .clk(clk), 
    .reset(reset), 
    .MDOp(MDOp), 
    .start(start), 
	 .Req(Req),
    .E_forward_RD1(E_forward_RD1), 
    .E_forward_RD2(E_forward_RD2), 
    .Busy(Busy), 
    .HI(HI), 
    .LO(LO)
    );
	 
	 assign E_exception_code = (E_temp_exception_code)? E_temp_exception_code:
																				(E_exception_AriOV)? 5'd12:
																				0;
////////////////////////////////////////////////////////////////////////// E level and we introduce EM_reg
	 
	 EM_reg EM_reg (
    .clk(clk), 
    .reset(reset), 
	 .Req(Req),
	 .E_PC(E_PC),
	 .E_Instr(E_Instr),
	 .E_RD2(E_forward_RD2),
	 .E_A3(E_A3),
    .ALUResult_in(E_ALUResult), 
	 .E_Tnew(E_Tnew),
	 .E_exception_code(E_exception_code),
	 .E_isDelay(E_isDelay),
	 .E_exception_DMOV(E_exception_DMOV),
	 .HI(HI),
	 .LO(LO),
    .ALUResult_out(M_ALUResult),
	 .M_PC(M_PC),
	 .M_Instr(M_Instr),
	 .M_RD2(M_RD2),
	 .M_A3(M_A3),
	 .M_Tnew(M_Tnew),
	 .M_HI(M_HI),
	 .M_LO(M_LO),
	 .M_temp_exception_code(M_temp_exception_code),
	 .M_isDelay(M_isDelay),
	 .M_exception_DMOV(M_exception_DMOV)
    );
	 
	 BE BE (
    .address(M_ALUResult[1:0]), 
    .m_data_rdata(m_data_rdata), 
    .BEOp(BEOp), 
    .M_DMRD(M_DMRD)
    );
	 	 
	 M_ctrl M_ctrl(
    .M_Instr(M_Instr), 
	 .M_ALUResult(M_ALUResult),
	 .M_PC(M_PC),
	 .M_HI(M_HI),
	 .M_LO(M_LO),
	 .M_WD(M_WD),
	 .m_data_byteen(temp_m_data_byteen),
	 .BEOp(BEOp),
	 .M_eret(M_eret),
	 .M_mtc0(M_mtc0)
    );
	 
	 assign M_exception_AdEL = (BEOp==3'b000&&(|M_ALUResult[1:0]))||
																				(BEOp==3'b011&&(M_ALUResult[0]))||
																				(((BEOp==3'b011)|(BEOp==3'b001))&&((M_ALUResult>=32'h7f00&&M_ALUResult<=32'h7f0b)||(M_ALUResult>=32'h7f10&&M_ALUResult<=32'h7f1b)))||
																				((BEOp==3'b000|BEOp==3'b001|BEOp==3'b011)&&(M_exception_DMOV))||
																				((BEOp==3'b000|BEOp==3'b001|BEOp==3'b011)&&!((M_ALUResult>=32'h0000&&M_ALUResult<=32'h2fff)|(M_ALUResult>=32'h7f00&&M_ALUResult<=32'h7f0b)|(M_ALUResult>=32'h7f10&&M_ALUResult<=32'h7f1b)|(M_ALUResult>=32'h7f20&&M_ALUResult<=32'h7f23)));
	//assign M_exception_AdES = signal1|signal2|signal3|signal4|signal5|signal6;
	assign M_exception_AdES = (temp_m_data_byteen==4'b1111&&(|M_ALUResult[1:0]))||
																				(((temp_m_data_byteen==4'b0011)|(temp_m_data_byteen==4'b1100))&&(M_ALUResult[0]))||
																				(((temp_m_data_byteen==4'b0011)|(temp_m_data_byteen==4'b1100)|(temp_m_data_byteen==4'b0001)|(temp_m_data_byteen==4'b0010)|(temp_m_data_byteen==4'b0100)|(temp_m_data_byteen==4'b1000))&&((M_ALUResult>=32'h7f00&&M_ALUResult<=32'h7f0b)||(M_ALUResult>=32'h7f10&&M_ALUResult<=32'h7f1b)))||
																				(((temp_m_data_byteen==4'b1111)|(temp_m_data_byteen==4'b0011)|(temp_m_data_byteen==4'b1100)|(temp_m_data_byteen==4'b0001)|(temp_m_data_byteen==4'b0010)|(temp_m_data_byteen==4'b0100)|(temp_m_data_byteen==4'b1000))&&(M_exception_DMOV))||
																				(((temp_m_data_byteen==4'b1111)|(temp_m_data_byteen==4'b0011)|(temp_m_data_byteen==4'b1100)|(temp_m_data_byteen==4'b0001)|(temp_m_data_byteen==4'b0010)|(temp_m_data_byteen==4'b0100)|(temp_m_data_byteen==4'b1000))&&((M_ALUResult>=32'h7f08&&M_ALUResult<=32'h7f0b)|(M_ALUResult>=32'h7f18&&M_ALUResult<=32'h7f1b)))||
																				(((temp_m_data_byteen==4'b1111)|(temp_m_data_byteen==4'b0011)|(temp_m_data_byteen==4'b1100)|(temp_m_data_byteen==4'b0001)|(temp_m_data_byteen==4'b0010)|(temp_m_data_byteen==4'b0100)|(temp_m_data_byteen==4'b1000))&&!((M_ALUResult>=32'h0000&&M_ALUResult<=32'h2fff)|(M_ALUResult>=32'h7f00&&M_ALUResult<=32'h7f0b)|(M_ALUResult>=32'h7f10&&M_ALUResult<=32'h7f1b)|(M_ALUResult>=32'h7f20&&M_ALUResult<=32'h7f23)));
    assign m_data_byteen = (Req)? 4'b0000: temp_m_data_byteen;
	 assign M_exception_code = (M_temp_exception_code)? M_temp_exception_code:
																				(M_exception_AdEL)? 5'd4:
																				(M_exception_AdES)? 5'd5:
																				0;
																				
	CP0 CP0 (
    .clk(clk), 
    .reset(reset), 
    .CP0_in(M_forward_RD2), 
    .CP0_A1(M_Instr[15:11]),//instruction's rd; 
    .CP0_A2(M_Instr[15:11]),//mtc0 in D_ctrl D_regWrite=0,so we specially take actions; 
    .exception_code(M_exception_code), 
    .M_PC(M_PC), 
    .HWInt(HWInt), 
    .CP0_WE(M_mtc0), 
    .EXLClr(M_eret), 
    .isDelay(M_isDelay), 
    .Req(Req), 
    .EPC_out(EPC_out), 
    .M_CP0_out(M_CP0_out)
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
	 .Req(Req),
	 .M_CP0_out(M_CP0_out),
    .W_ALUResult(W_ALUResult), 
    .W_DMRD(W_DMRD), 
    .W_A3(W_A3), 
    .W_PC(W_PC),
	 .W_Instr(W_Instr),
	 .W_Tnew(W_Tnew),
	 .W_HI(W_HI),
	 .W_LO(W_LO),
	 .W_CP0_out(W_CP0_out)
    );

    W_ctrl W_ctrl(
    .W_Instr(W_Instr), 
	 .W_ALUResult(W_ALUResult),
	 .W_DMRD(W_DMRD),
	 .W_CP0_out(W_CP0_out),
	 .W_PC(W_PC),
	 .W_HI(W_HI),
	 .W_LO(W_LO),
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
	 .D_eret(D_eret),
	 .E_mtc0(E_mtc0),
	 .E_Instr(E_Instr),
	 .M_mtc0(M_mtc0),
	 .M_Instr(M_Instr),
	 .HILO_operation(HILO_operation),
	 .start(start),
	 .Busy(Busy),
	 .stall(stall)
    );

endmodule
