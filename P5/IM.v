`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:52:30 11/23/2023 
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
				input [31:0] i_inst_addr,
				output [31:0] i_inst_rdata
    );
reg [31:0] inst[0:4095];
initial begin
        $readmemh("code.txt", inst);
    end
assign i_inst_rdata = inst[(i_inst_addr - 32'h3000) >> 2];
endmodule
