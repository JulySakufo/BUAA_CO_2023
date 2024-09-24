`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:29:55 11/01/2023 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    inout [31:0] WD,
    input clk,
    input reset,
    input WE,
	 input [31:0] PC,
    output [31:0] RD1,
    output [31:0] RD2
    );
reg [31:0] registers[31:0];//32 registers
integer i;

always@(posedge clk) begin
    if(reset==1) begin //reset, the most priority
        for(i=0;i<32;i=i+1) begin
            registers[i] = 32'b0;
        end
    end
	 
	 else begin //write needs the clk,so we take actions when clk comes
	     if(WE==1) begin
            if(A3!=5'b0) begin // not $0,writedata into registers to change the data
		      registers[A3] <= WD;
				$display("@%h: $%d <= %h", PC, A3, WD);				    
				end
		  end
	 end
end

assign RD1 = registers[A1];
assign RD2 = registers[A2];//read
endmodule
