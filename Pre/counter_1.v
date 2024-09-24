`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:44:05 08/25/2023 
// Design Name: 
// Module Name:    code
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
module code(
    input Clk,
    input Reset,
    input Slt,
    input En,
    output reg [63:0] Output0,
    output reg [63:0] Output1
    );
reg [3:0] status;
initial begin
status<=4'b0;
Output0<=64'b0;
Output1<=64'b0;
end

always@(posedge Clk) begin
         if(Reset==1'b1) begin
			      Output0<=64'b0;
					Output1<=64'b0;
					status<=4'b0;
				end
         else if(En==1'b1) begin
	          if(Slt==1'b0) begin
		          Output0<=Output0+64'b1;
		   end
		      else if(Slt==1'b1) begin
		   if(status==4'b0011) begin
			     status<=4'b0;
				  Output1<=Output1+64'b1;
			end
		    else begin
		    	status<=status+4'b1;
		    end
		end
	end
	else begin
	           Output0<=Output0;
				  Output1<=Output1;
		end
end
endmodule
