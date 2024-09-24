`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:01:37 11/23/2023 
// Design Name: 
// Module Name:    BE 
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
`define LW 3'b000
`define LB 3'b001
`define LBU 3'b010
`define LH 3'b011
`define LHU 3'b100
module BE(
    input [1:0] address,
	 input [31:0] m_data_rdata,//from dm's data,need instruction to extend to accurate data
	 input [2:0] BEOp,
	 output [31:0] M_DMRD
    );

assign M_DMRD = (BEOp==`LW)? m_data_rdata:
												(BEOp==`LH&&address[1]==0)? {{16{m_data_rdata[15]}},m_data_rdata[15:0]} :
												(BEOp==`LH&&address[1]==1)? {{16{m_data_rdata[31]}},m_data_rdata[31:16]}:
												(BEOp==`LB&&address==0)? {{24{m_data_rdata[7]}},m_data_rdata[7:0]}:
												(BEOp==`LB&&address==1)? {{24{m_data_rdata[15]}},m_data_rdata[15:8]}:
												(BEOp==`LB&&address==2)? {{24{m_data_rdata[23]}},m_data_rdata[23:16]}:
												(BEOp==`LB&&address==3)? {{24{m_data_rdata[31]}},m_data_rdata[31:24]}:
												0;//correct data
endmodule
