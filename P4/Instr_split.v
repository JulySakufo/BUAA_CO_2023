`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:08:51 11/02/2023 
// Design Name: 
// Module Name:    Instr_split 
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
module Instr_split(
    input [31:0] Instr,
    output [5:0] opcode,
    output [5:0] funct,
    output [4:0] Instr25_21,
    output [4:0] Instr20_16,
    output [4:0] Instr15_11,
    output [15:0] immediate_16,
    output [25:0] Instr25_0
    );
assign opcode = Instr[31:26];
assign Instr25_21 = Instr[25:21];
assign Instr20_16 = Instr[20:16];
assign Instr15_11 = Instr[15:11];
assign immediate_16 = Instr[15:0];
assign funct = Instr[5:0];
assign Instr25_0 = Instr[25:0];

endmodule
