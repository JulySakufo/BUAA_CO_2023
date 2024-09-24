`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:01:06 11/02/2023 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input clk,
    input reset,
    input [2:0] PCSrc,
    input [31:0] immediate_32,
    input [25:0] immediate_26,
	 input [31:0] ra,
	 input [31:0] D_PC,
	 input stall,
	 input Req,
	 input [31:0] EPC_out,
    output [31:0] pc_out
    );
reg [31:0] pc;
wire [31:0] offset = {{14{immediate_26[15]}},immediate_26[15:0],2'b0};
wire [31:0] pc31_28_instr_0 = {D_PC[31:28],immediate_26,2'b0};//update the beq's calculation
assign pc_out = pc;
always@(posedge clk) begin
    if(reset==1) begin
	     pc<=32'h3000;
	 end
	 else begin
	     if(Req) begin
		      pc<=32'h0000_4180;
		  end
	     else if(stall==1) begin//reset>Req>stall/flush
		      pc<=pc;
		  end
		  else
	     if(PCSrc==3'b000) begin
		      pc <= pc+4;
		  end
		  else if(PCSrc==3'b001) begin
		      pc<=D_PC+4+offset;//for the delayed branch,the instruction should be D_pc+4+offset,not F_PC+offset
		  end
		  else if(PCSrc==3'b010) begin
		      pc<=pc31_28_instr_0;
		  end
		  else if(PCSrc==3'b011) begin
		      pc<=ra;
		  end
		  else if(PCSrc==3'b100) begin
		      pc<=EPC_out+4;
		  end
		  end
end
endmodule