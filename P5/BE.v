`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:51:00 11/16/2023 
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
`define LBU 3'b001
`define LB 3'b010
`define LHU 3'b011
`define LH 3'b100
module BE(
    input [1:0] A,
    input [31:0] Din,
    input [2:0] Op,
    output [31:0] Dout
    );
	 wire [4:0]_byte = 8*A;
	 wire [4:0]_half = 16*A[1];
	 wire [7:0] byte_data;
	 wire [15:0] half_data;
	 assign byte_data = (_byte==0)? Din[7:0]:
														(_byte==8)? Din[15:8]:
														(_byte==16)? Din[23:16]:
														(_byte==24)? Din[31:24]:
														0;
	assign half_data = (_half==0)? Din[15:0]:
													(_half==16)? Din[31:16]:
													0;
assign Dout = (Op==`LW)? Din:
									(Op==`LBU)? {24'b0,byte_data}:
									(Op==`LB)? {{24{byte_data[7]}},byte_data}:
									(Op==`LHU)? {16'b0,half_data}:
									(Op==`LH)? {{16{half_data[15]}},half_data}:
									0;
									
endmodule
