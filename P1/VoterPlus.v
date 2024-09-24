`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:55:13 10/03/2023 
// Design Name: 
// Module Name:    VoterPlus 
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
module VoterPlus(
    input clk,
    input reset,
    input [31:0] np,
    input [7:0] vip,
    input vvip,
    output reg [7:0] result
    );
integer i;
integer j;
integer k;
initial begin
i=0;
j=0;
k=0;
result<=0;
end

always@(posedge clk or posedge reset) begin
        if(reset==1) begin
		          result<=0;
		  end
		  else begin
		          for(i=0;i<32;i=i+1) begin
					         if(np[i]==1) begin
								        result = result+1;
								end
					 end
					 for(j=0;j<8;j=j+1) begin
					         if(vip[j]==1) begin
								        result = result+4;
								end
					 end
					 
					 for(k=0;k<1;k=k+1) begin
					         if(vvip==1) begin
					         result = result+16;
					 end
					 end
		  end
end
endmodule
