`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:35:40 10/11/2023 
// Design Name: 
// Module Name:    expr 
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

module expr(
    input clk,
    input clr,
    input [7:0] in,
    output out
    );
reg [1:0] status;
initial begin
        status<=`s0;
end

always@(posedge clk or posedge clr) begin
        if(clr==1) begin// when clr=1,reset;
		          status<=`s0;
		  end
		  else begin
        case(status)
		  `s0: begin
		          if(in>="0"&&in<="9") begin
					         status<=`s1;//legal
					 end
					 else begin
					         status<=`s3;//keep illegal all time until reset again;
					 end
		  end
		  
		  `s1:begin
		          if(in=="+"||in=="*") begin
					         status<=`s0;//1+ go back to check whether is number;
					 end
					 else begin
					         status<=`s3;
					 end
		  end
		  endcase
		  end
end
assign out=(status==`s1)?1:0;
endmodule
