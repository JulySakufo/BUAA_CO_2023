`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:54:40 10/11/2023 
// Design Name: 
// Module Name:    ext 
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
module ext(
    input [15:0] imm,
    input [1:0] EOp,
    output [31:0] ext
    );
	 reg [15:0] zero;
	 reg [15:0] one;
initial begin
        zero=0;
		  one = 16'b1111_1111_1111_1111;
end


        assign ext = (EOp==0&&imm[15]==0)? {zero,imm}:
                                (EOp==0&&imm[15]==1)? {one,imm}:
                                (EOp==1)? {zero,imm}:
                                (EOp==2)? {imm,zero}:
                                (EOp==3&&imm[15]==0)? (({zero,imm})<<2) :
										  (EOp==3&&imm[15]==1)? (({one,imm})<<2):
										  0;

endmodule
