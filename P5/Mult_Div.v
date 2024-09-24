`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:54:06 11/16/2023 
// Design Name: 
// Module Name:    Mult_Div 
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
`define MULT 4'b0000
`define MULTU 4'b0001
`define DIV 4'b0010
`define DIVU 4'b0011
`define MFHI 4'b0100
`define MFLO 4'b0101
`define MTHI 4'b0110
`define MTLO 4'b0111
module Mult_Div(
    input clk,
	 input reset,
    input [31:0] E_RD1,
	 input [31:0] E_RD2,
	 input E_Start,//whether is mult or div,if is->1,or 0
	 input [3:0] Op,
	 output reg [31:0] HI,
	 output reg [31:0] LO,
	 output reg Busy
    );
reg [63:0] mult_result;
reg [63:0] multu_result;
reg [31:0] div_result;
reg [31:0] mod_result;
reg [31:0] DIV_result;
reg [31:0] MOD_result;
reg [3:0] cycle_cnt;
reg [3:0] lastOp;
always@(posedge clk) begin
    if(reset==1) begin
	     HI<=0;
		  LO<=0;
		  Busy<=0;
	 end
	 else begin
	 if(E_Start==1) begin
		  Busy<=1;//last a period;
	 end
	 if(Busy==1) begin
	     if(cycle_cnt==1) begin
		      Busy<=0;
				if(lastOp==`MULT) begin
				    HI<=mult_result[63:32];
					 LO<=mult_result[31:0];
				end
				else if(lastOp==`MULTU) begin
				    HI<=multu_result[63:32];
					 LO<=multu_result[31:0];
				end
				else if(lastOp==`DIV) begin
				    HI<=mod_result;
					 LO<=div_result;
				end
				else if(lastOp==`DIVU) begin
				    HI<=MOD_result;
					 LO<=DIV_result;
				end
		  end
		  else begin
		      cycle_cnt<=cycle_cnt-1;
		  end
	 end
	 else begin//empty,waiting for operations
	     if(Op==`MULT) begin
				mult_result<=$signed(E_RD1)*$signed(E_RD2);//as soon as possible get result
				cycle_cnt<=5;//get cycle period
				lastOp<=Op;
		  end
		  else if(Op==`MULTU) begin
				multu_result<=E_RD1*E_RD2;
				cycle_cnt<=5;
				lastOp<=Op;
		  end
		  else if(Op==`DIV) begin
				div_result<=$signed(E_RD1)/$signed(E_RD2);
				mod_result<=$signed(E_RD1)%$signed(E_RD2);
				cycle_cnt<=10;
				lastOp<=Op;
		  end
		  else if(Op==`DIVU) begin
				DIV_result<=E_RD1/E_RD2;
				MOD_result<=E_RD1%E_RD2;
				cycle_cnt<=10;
				lastOp<=Op;
		  end
		  else if(Op==`MTHI) begin
		      HI<=E_RD1;
		  end
		  else if(Op==`MTLO) begin
		      LO<=E_RD1;
		  end
	 end
	 end
end

endmodule
