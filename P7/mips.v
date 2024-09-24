`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:30:08 12/01/2023 
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
	input reset,
	input interrupt,
	output [31:0] macroscopic_pc,
	
	output [31:0] i_inst_addr, 
	input  [31:0] i_inst_rdata,
	
	output [31:0] m_data_addr,
	input  [31:0] m_data_rdata,
	output [31:0] m_data_wdata,
	output [3 :0] m_data_byteen,
	
	output [31:0] m_int_addr,  
	output [3 :0] m_int_byteen,
	
	output [31:0] m_inst_addr,
	
	output w_grf_we, 
	output [4 :0] w_grf_addr, 
	output [31:0] w_grf_wdata,
	
	output [31:0] w_inst_addr
    );
	 
	 wire [31:0] temp_m_data_addr;
	wire [31:0] temp_m_data_wdata;
	wire [3:0] temp_m_data_byteen;
	wire [31:0] temp_m_data_rdata;
	wire [31:0] TC0_data_rdata;
	wire [31:0] TC1_data_rdata;
	wire TC0_WE;
	wire TC1_WE;
	wire TC0_IRQ;
	wire TC1_IRQ;	 
	wire [5:0] HWInt;
	assign HWInt = {3'b0,interrupt,TC1_IRQ,TC0_IRQ};
	assign m_int_addr = m_data_addr;
	assign m_int_byteen = m_data_byteen;
mips_CPU mips_CPU (
    .clk(clk), 
    .reset(reset), 
    .i_inst_rdata(i_inst_rdata), 
    .m_data_rdata(m_data_rdata), 
	 .HWInt(HWInt),
    .i_inst_addr(i_inst_addr), 
    .m_data_addr(temp_m_data_addr), 
    .m_data_wdata(temp_m_data_wdata), 
    .m_data_byteen(temp_m_data_byteen), 
    .m_inst_addr(m_inst_addr), 
    .w_grf_we(w_grf_we), 
    .w_grf_addr(w_grf_addr), 
    .w_grf_wdata(w_grf_wdata), 
    .w_inst_addr(w_inst_addr),
	 .macroscopic_pc(macroscopic_pc)
    );

Bridge Bridge (
    .temp_m_data_addr(temp_m_data_addr), 
    .temp_m_data_wdata(temp_m_data_wdata), 
    .temp_m_data_byteen(temp_m_data_byteen), 
    .temp_m_data_rdata(temp_m_data_rdata), 
    .m_data_addr(m_data_addr), 
    .m_data_wdata(m_data_wdata), 
    .m_data_byteen(m_data_byteen), 
    .m_data_rdata(m_data_rdata), //from dm's data
    .TC0_data_rdata(TC0_data_rdata), 
    .TC1_data_rdata(TC1_data_rdata), 
    .TC0_WE(TC0_WE), 
    .TC1_WE(TC1_WE)
    );


TC TC0 (
    .clk(clk), 
    .reset(reset), 
    .Addr(m_data_addr[31:2]), 
    .WE(TC0_WE), 
    .Din(m_data_wdata), 
    .Dout(TC0_data_rdata), 
    .IRQ(TC0_IRQ)
    );

TC TC1 (
    .clk(clk), 
    .reset(reset), 
    .Addr(m_data_addr[31:2]), 
    .WE(TC1_WE), 
    .Din(m_data_wdata), 
    .Dout(TC1_data_rdata), 
    .IRQ(TC1_IRQ)
    );


endmodule
