`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:14:01 10/11/2023 
// Design Name: 
// Module Name:    gray 
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
module gray(
    input Clk,
    input Reset,
    input En,
    output [2:0] Output,
    output reg Overflow
    );
reg [2:0]decimal_cnt;
initial begin
decimal_cnt<=3'b000;
Overflow<=0;
end
always@(posedge Clk) begin
        if(Reset==1) begin
					 decimal_cnt<=0;
					 Overflow<=0;
		  end
		  else begin
		          if(En==1) begin
					         if(decimal_cnt==3'b111) begin
								     Overflow<=1;//overflow
								end
					         decimal_cnt<=decimal_cnt+1;
					 end
		  end
end
assign Output = (decimal_cnt==3'b000)? 3'b000:
                                (decimal_cnt==3'b001)? 3'b001:
										  (decimal_cnt==3'b010)? 3'b011:
										  (decimal_cnt==3'b011)? 3'b010:
										  (decimal_cnt==3'b100)? 3'b110:
										  (decimal_cnt==3'b101)? 3'b111:
										  (decimal_cnt==3'b110)? 3'b101:
										  (decimal_cnt==3'b111)? 3'b100:
										  0;
endmodule
