`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:27:35 10/03/2023 
// Design Name: 
// Module Name:    drink 
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
`define s0 0
`define s1 1
`define s2 2
`define s3 3
`define s4 4
`define s5 5

module drink(
    input clk,
    input reset,
    input [1:0] coin,
    output reg drink,
    output reg [1:0] back
    );
reg [2:0] status;
initial begin
        status<=`s0;
end
always@(reset) begin
        if(reset==1) begin
		          drink=0;
					 back=0;
					 status=`s0;
		  end
end
always@(posedge clk) begin
        if(reset==1) begin
		          drink<=0;
					 back<=0;
					 status<=`s0;
		  end
		  else begin
		          case(status)
					 `s0: begin
					         drink<=0;
								back<=2'b00;
					         if(coin==2'b00) begin
								        status<=`s0;
								end
								else if(coin==2'b01) begin
								        status<=`s1;
								end
								else if(coin==2'b10) begin
								        status<=`s2;
								end
								else begin
								        status<=`s0;
								       back<=2'b00;
								end
					 end
					 
					 `s1: begin
					         drink<=0;
					         if(coin==2'b00) begin
								        status<=`s1;
								end
								else if(coin==2'b01) begin
								        status<=`s2;
								end
								else if(coin==2'b10) begin
								        status<=`s3;
								end
								else begin
								        status<=`s0;
								        back<=2'b01;
								end
					 end
					 
					 `s2: begin
					         drink<=0;
					          if(coin==2'b00) begin
								        status<=`s2;
								end
								else if(coin==2'b01) begin
								        status<=`s3;
								end
								else if(coin==2'b10) begin
								        status<=`s0;
										  drink<=1;
								end
								else begin
								        status<=`s0;
								        back<=2'b10;
								end
					 end
					 
					 `s3: begin
					         drink<=0;
					         if(coin==2'b00) begin
								        status<=`s3;
								end
								else if(coin==2'b01) begin
								        drink<=1;
										  back<=0;
								        status<=`s0;
								end
								else if(coin==2'b10) begin
								        drink<=1;
										  back<=2'b01;
								        status<=`s0;
								end
								else begin
								        status<=`s0;
								        back<=2'b11;
								end
					 end
					 
					 /*`s4:begin
					         drink<=0;
								back<=0;
								if(coin==2'b00) begin
								        status<=`s0;
										  sum<=0;
								end
								else if(coin==2'b01) begin
								        status<=`s1;
										  sum<=5;
								end
								else if(coin==2'b10) begin
								        status<=`s2;
										  sum<=10;
								end
								else begin
								        status<=`s0;
										  sum<=0;
								end
					 end
					 
					 `s5: begin
					         drink<=0;
								back<=2'b00;
								if(coin==2'b00) begin
								        status<=`s0;
										  sum<=0;
								end
								else if(coin==2'b01) begin
								        status<=`s1;
										  sum<=5;
								end
								else if(coin==2'b10) begin
								        status<=`s2;
										  sum<=10;
								end
								else begin
								        status<=`s0;
										  sum<=0;
								end
					 end*/
					 endcase
		  end
end

endmodule
