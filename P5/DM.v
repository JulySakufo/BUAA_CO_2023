`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:57:10 11/23/2023 
// Design Name: 
// Module Name:    DM 
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
`define LBU 3'b001
`define LB 3'b010
`define LHU 3'b011
`define LH 3'b100
module DM(
    input clk,
	 input reset,
	 input [31:0]PC,
    input [31:0] M_ALUResult,
    input [31:0] M_forward_RD2,
    input [3 :0] m_data_byteen,
	 input [2:0] Op,
	 output [31:0] m_data_rdata
    );
	 integer i;
	 wire [1:0] A=M_ALUResult;
	 reg [31:0] data[0:4095];
	 wire [31:0] factwrite;
	 reg [31:0] fixed_addr;
    reg [31:0] fixed_wdata;
	 wire [4:0]_byte = 8*A;
	 wire [4:0]_half = 16*A[1];
	 wire [7:0] byte_data;
	 wire [15:0] half_data;
	 wire [31:0] Din;
assign factwrite = (m_data_byteen==4'b1111)? M_forward_RD2:
																	(m_data_byteen==4'b0011)? M_forward_RD2:
																	(m_data_byteen==4'b1100)? (M_forward_RD2<<16):
																	(m_data_byteen==4'b0001)? M_forward_RD2:
																	(m_data_byteen==4'b0010)? (M_forward_RD2<<8):
																	(m_data_byteen==4'b0100)? (M_forward_RD2<<16):
																	(m_data_byteen==4'b1000)? (M_forward_RD2<<24):
																	0;
																	
always @(*) begin
        fixed_wdata = data[M_ALUResult >> 2];
        fixed_addr = M_ALUResult & 32'hfffffffc;
        if (m_data_byteen[3]) fixed_wdata[31:24] = factwrite[31:24];
        if (m_data_byteen[2]) fixed_wdata[23:16] = factwrite[23:16];
        if (m_data_byteen[1]) fixed_wdata[15: 8] = factwrite[15: 8];
        if (m_data_byteen[0]) fixed_wdata[7 : 0] = factwrite[7 : 0];
    end
	 
	 always @(posedge clk) begin
        if (reset) for (i = 0; i < 4096; i = i + 1) data[i] <= 0;
        else if (|m_data_byteen) begin
            data[fixed_addr >> 2] <= fixed_wdata;
            $display("%d@%h: *%h <= %h", $time, PC, fixed_addr, fixed_wdata);
        end
    end
assign Din= data[M_ALUResult >> 2];
	 assign byte_data = (_byte==0)? Din[7:0]:
														(_byte==8)? Din[15:8]:
														(_byte==16)? Din[23:16]:
														(_byte==24)? Din[31:24]:
														0;
	assign half_data = (_half==0)? Din[15:0]:
													(_half==16)? Din[31:16]:
													0;
assign m_data_rdata = (Op==`LW)? Din:
									(Op==`LBU)? {24'b0,byte_data}:
									(Op==`LB)? {{24{byte_data[7]}},byte_data}:
									(Op==`LHU)? {16'b0,half_data}:
									(Op==`LH)? {{16{half_data[15]}},half_data}:
									0;
endmodule
