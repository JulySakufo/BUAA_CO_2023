`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:34:51 11/02/2023 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input [31:0] address,
    input [31:0] writedata,
    input clk,
    input WE,
    input reset,
    input [2:0] DMOp,
	 input [31:0] PC,
    output [31:0] readdata
    );
reg [31:0] RAM [4095:0];
wire [31:0] factwrite;
wire [11:0] address13_2 = address[13:2];
wire [31:0] memword = RAM[address13_2];
wire [7:0] memword7_0 = memword[7:0];
wire [7:0] memword15_8 = memword[15:8];
wire [7:0] memword23_16 = memword[23:16];
wire [7:0] memword31_24 = memword[31:24];
wire address1 = address[1];
wire [1:0] address1_0 = address[1:0];
wire [7:0] writedata7_0 = writedata[7:0];
wire [7:0] writedata15_8 = writedata[15:8];
wire [7:0] writedata23_16 = writedata[23:16];
wire [7:0] writedata31_24 = writedata[31:24];
integer i;
assign readdata = (DMOp==3'b0)? 32'b0:
                                    (DMOp==3'b1)? memword:
												(DMOp==3'b10&&address1==0)? {{16{memword[15]}},memword15_8,memword7_0}:
												(DMOp==3'b10&&address1==1)? {{16{memword[15]}},memword31_24,memword23_16}:
												(DMOp==3'b11&&address1_0==0)? {{24{memword[7]}},memword7_0}:
												(DMOp==3'b11&&address1_0==1)? {{24{memword[15]}},memword15_8}:
												(DMOp==3'b11&&address1_0==2)? {{24{memword[23]}},memword23_16}:
												(DMOp==3'b11&&address1_0==3)? {{24{memword[31]}},memword31_24}:
												0;
												
 assign factwrite = (DMOp==3'b0)? 32'b0:
												 (DMOp==3'b1)? writedata:
												 (DMOp==3'b10&&address1==0)? {memword31_24,memword23_16,writedata15_8,writedata7_0}:
												 (DMOp==3'b10&&address1==1)? {writedata15_8,writedata7_0,memword15_8,memword7_0}:
												 (DMOp==3'b11&&address1_0==0)? {memword31_24,memword23_16,memword15_8,writedata7_0}:
												 (DMOp==3'b11&&address1_0==1)? {memword31_24,memword23_16,writedata7_0,memword7_0}:
												 (DMOp==3'b11&&address1_0==2)? {memword31_24,writedata7_0,memword15_8,memword7_0}:
												 (DMOp==3'b11&&address1_0==3)? {writedata7_0,memword23_16,memword15_8,memword7_0}:
												 0;
												 
always@(posedge clk) begin
    if(reset==1) begin
	     for(i=0;i<4096;i=i+1) begin
		      RAM[i]=0;
		  end
	 end
	 
	 else begin
	     if(WE==1) begin
		      RAM[address13_2] = factwrite;
				$display("@%h: *%h <= %h", PC, address, factwrite);
		  end
	 end
end
endmodule
