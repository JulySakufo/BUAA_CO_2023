`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:13:30 12/01/2023 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
	input [31:0] temp_m_data_addr,
	input [31:0] temp_m_data_wdata,
	input [3:0] temp_m_data_byteen,
	output [31:0] temp_m_data_rdata,//from cpu
	
	output [31:0] m_data_addr,
	output [31:0] m_data_wdata,
	output [3:0] m_data_byteen,
	input [31:0] m_data_rdata,//from tb's dm's data
	
	input [31:0] TC0_data_rdata,
	input [31:0] TC1_data_rdata,
	output TC0_WE,
	output TC1_WE
    );

assign m_data_addr = temp_m_data_addr;
assign m_data_wdata = temp_m_data_wdata;
assign m_data_byteen = temp_m_data_byteen;

assign TC0_WE = (temp_m_data_addr>=32'h7f00&&temp_m_data_addr<=32'h7f0b&&(&temp_m_data_byteen))? 1:0;
assign TC1_WE = (temp_m_data_addr>=32'h7f10&&temp_m_data_addr<=32'h7f1b&&(&temp_m_data_byteen))? 1:0;
assign temp_m_data_rdata = (temp_m_data_addr>=32'h7f00&&temp_m_data_addr<=32'h7f0b)? TC0_data_rdata:
																  (temp_m_data_addr>=32'h7f10&&temp_m_data_addr<=32'h7f1b)? TC1_data_rdata:
																  (temp_m_data_addr>=32'h0000&&temp_m_data_addr<=32'h2fff)? m_data_rdata:
																  0;
endmodule
