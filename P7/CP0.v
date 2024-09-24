`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:41:56 11/30/2023 
// Design Name: 
// Module Name:    CP0 
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
`define IM SR[15:10]
`define EXL SR[1]
`define IE SR[0]
`define BD Cause[31]
`define IP Cause[15:10]
`define ExcCode Cause[6:2]
module CP0(
    input clk,
	 input reset,
	 input [31:0] CP0_in,//data from grf;
	 input [4:0] CP0_A1,
	 input [4:0] CP0_A2,
	 input [4:0] exception_code,
	 input [31:0] M_PC,
	 input [5:0] HWInt,
	 input CP0_WE,
	 input EXLClr,
	 input isDelay,
	 output Req,
	 output [31:0] EPC_out,
	 output [31:0] M_CP0_out
    );
	 
	 reg [31:0] SR;
	 reg [31:0] Cause;
	 reg [31:0] EPC;
	 wire IntReq;
	 wire ExcReq;
always@(posedge clk) begin
    if(reset) begin
	     SR<=0;
		  Cause<=0;
		  EPC<=0;
	 end
	 else begin
		if(EXLClr) begin//when M_eret comes
		    `EXL<=0;
		end
		if(Req) begin
			`ExcCode <= IntReq? 0:exception_code;
			`EXL<=1;//make Req->0
			EPC<= isDelay? M_PC-4 : M_PC;
			`BD<=isDelay;
	     end
		else if(CP0_WE) begin//when mtc0
		    if(CP0_A2==12) begin
			     `IM<=CP0_in[15:10];
				  `EXL<=CP0_in[1];
				  `IE<=CP0_in[0];
			 end
			 else if(CP0_A2==14) begin
			     EPC<=CP0_in;
			 end
		end
		`IP<=HWInt;//update each period
	 end
end

assign IntReq = (|((`IM)&(HWInt)))&(`IE)&(!`EXL);
assign ExcReq = (|exception_code)&(!`EXL);

assign Req = (IntReq)|(ExcReq);
assign EPC_out = EPC;
assign M_CP0_out = (CP0_A1==12)? SR:
											  (CP0_A1==13)? Cause:
											  (CP0_A1==14)? EPC:
											  0;
endmodule
