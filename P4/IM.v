`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:20:11 11/02/2023 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input [31:0] PC,
    output [31:0] Instr
    );
reg [31:0] ROM [4095:0];//ROM's birth
initial begin
    $readmemh("code.txt",ROM);
end
wire [31:0] subPC = (PC-32'h3000);//difference with logisim
wire [11:0] factPC = subPC[13:2];
assign Instr = ROM[factPC];
endmodule
