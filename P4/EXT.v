`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:57:41 11/01/2023 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
    input [15:0] immediate_16,
    input ExtOp,
    output [31:0] immediate_32
    );
assign immediate_32 = (ExtOp==0)? {16'b0,immediate_16}:
															  (ExtOp==1)? {{16{immediate_16[15]}},immediate_16}:
															  0;
//ExtOp=0, zero extend,ExtOp=1,sign extend;
endmodule
