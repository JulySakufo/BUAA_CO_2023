`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:06:25 11/23/2023 
// Design Name: 
// Module Name:    MDU 
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
module MDU(
		input clk,
		input reset,
		input [3:0] MDOp,
		input start,
		input [31:0] E_forward_RD1,
		input [31:0] E_forward_RD2,
		output reg Busy,
		output reg [31:0] HI,
		output reg [31:0] LO
    );
reg [31:0] temp_HI;
reg [31:0] temp_LO;
reg [3:0] cycle_cnt;
always@(posedge clk) begin
    if(reset==1) begin
	     Busy<=0;
		  HI<=0;
		  LO<=0;
		  temp_HI<=0;
		  temp_LO<=0;
		  cycle_cnt<=0;
	 end
	 else begin
	     if(start==1) begin
		      Busy<=1;
		  end
		  if(cycle_cnt==0) begin
		      if(MDOp==`MULT) begin
				    {temp_HI,temp_LO}<=$signed(E_forward_RD1)*$signed(E_forward_RD2);
					 cycle_cnt<=5;
				end
				else if(MDOp==`MULTU) begin
				    {temp_HI,temp_LO}<=E_forward_RD1*E_forward_RD2;
					 cycle_cnt<=5;
				end
				else if(MDOp==`DIV) begin
				    temp_HI<=$signed(E_forward_RD1)%$signed(E_forward_RD2);
					 temp_LO<=$signed(E_forward_RD1)/$signed(E_forward_RD2);
					 cycle_cnt<=10;
				end
				else if(MDOp==`DIVU) begin
				    temp_HI<=E_forward_RD1%E_forward_RD2;
					 temp_LO<=E_forward_RD1/E_forward_RD2;
					 cycle_cnt<=10;
				end
				else if(MDOp==`MTHI) begin
				    HI<=E_forward_RD1;
				end
				else if(MDOp==`MTLO) begin
				    LO<=E_forward_RD1;
				end
		  end
		 else if(cycle_cnt==1) begin
		     HI<=temp_HI;
			  LO<=temp_LO;
			  cycle_cnt<=0;
			  Busy<=0;
		 end
		 else begin
		     cycle_cnt<=cycle_cnt-1;
		 end
	 end
end

endmodule
