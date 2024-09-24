`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:32:59 09/30/2023 
// Design Name: 
// Module Name:    intcheck 
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
`define s6 6
`define s7 7
`define s8 8
`define s9 9
`define s14 14
`define s15 15//if illegal and we don't get the ; means it's a fault and we need to wait for ;
module intcheck(
    input clk,
    input reset,
    input [7:0] in,
    output out
    );
reg [3:0] status;
reg [3:0] cnt;
initial begin
        status<=`s0;
		  cnt<=0;
end
always@(posedge clk) begin
        if(reset==1) begin
		          status<=`s0; // reset to original;
		  end
		  else begin
		          case(status)
					 `s0: begin
					         if(in==" "||in=="	") begin
								        status<=`s0;
								end
					         else if(in==";") begin
								        status<=`s0;
								end
					         else if(in=="i") begin
								        status<=`s1;
								end
								else begin
								        status<=`s15;
								end
					 end
					 
					 `s1:begin
					         if(in==";") begin
								        status<=`s0;
								end
					         else if(in=="n") begin
								        status<=`s2;
								end
								else begin
								        status<=`s15;
								end
					 end
					 
					 `s2: begin
					         if(in==";") begin
								        status<=`s0;
								end
					         else if(in=="t") begin
								        status<=`s3;
								end
								else begin
								        status<=`s15;
								end
					 end
					 
					 `s3:begin
					         if(in==";") begin
								        status<=`s0;
								end
					         else if(in==" "||in=="	")begin
								        status<=`s4;
								end
								else begin
								        status<=`s15;
								end
					 end
					 
					 `s4:begin
					         if(in==";"&&cnt==0) begin
								        status<=`s0;
								end
					         else if(in==";"&&cnt!=0) begin
								        status<=`s14;//the sentence ends and we need to print 1 and reset;
								end
					         else if((in==" "||in=="	")&&cnt==0)begin
								        status<=`s4;
								end
								else if((in==" "||in=="	")&&cnt!=0) begin
								        status<=`s4;
										  cnt<=2;
								end
								else if(in>="0"&&in<="9"&&cnt==0) begin//the first identifier can't be the number
								        status<=`s15;
								end
								else if(in>="0"&&in<="9"&&cnt==1) begin
								        status<=`s4;
								end
								else if(in=="i"&&cnt==0) begin
								        status<=`s5;//the first identifier is i,we should consider the int's coming
										  cnt<=1;
								end
								else if(in>="a"&&in<="z"&&cnt!=2) begin
								        status<=`s4;
										  cnt<=1;
								end
								else if(in>="A"&&in<="Z"&&cnt!=2) begin
								        status<=`s4;
										  cnt<=1;
								end
								else if(in=="_"&&cnt!=2) begin
								        status<=`s4;
										  cnt<=1;
								end
								else if(in==","&&cnt!=0) begin
								        status<=`s4;
										  cnt<=0;
								end
								else begin
								        status<=`s15;
										  cnt<=0;
								end
					 end
					 
					 `s5:begin
					         if(in==" "||in=="	") begin
								        status<=`s5;
										  cnt<=2;
								end
					         else if(in==",") begin
								        status<=`s4;
										  cnt<=0;
								end
					         else if(in==";") begin
								        status<=`s14;
										  cnt<=0;
								end
					         else if(in=="n"&&cnt!=2) begin
								        status<=`s6;
								end
								else if(((in>="0"&&in<="9")||(in>="a"&&in<="z")||(in>="A"&&in<="Z")||(in=="_")) &&cnt!=2)begin
								        status<=`s4; //the identifier can't be the int, since go back to normal states
								end
								else begin
								        status<=`s15;
								end
					 end
					 
					 `s6:begin
					         if(in==" "||in=="	") begin
								        status<=`s5;
										  cnt<=2;
								end
					         else if(in==";") begin
								        status<=`s14;
										  cnt<=0;
								end
							   else if(in==",") begin
								        status<=`s4;
										  cnt<=0;
								end
					         else if(in=="t"&&cnt!=2) begin
								        status<=`s7;//now the identifier is int
								end
								else if(((in>="0"&&in<="9")||(in>="a"&&in<="z")||(in>="A"&&in<="Z")||(in=="_")) &&cnt!=2)begin
								        status<=`s4;
								end
								else begin
								        status<=`s15;
								end
					 end
					 
					 `s7: begin//now the identifier is int
					         if(in==";") begin
								        status<=`s0;
										  cnt<=0;
								end
					         else if((in>="0"&&in<="9")||(in>="a"&&in<="z")||(in>="A"&&in<="Z")||(in=="_")) begin
								        status<=`s4;// the sentence may be reasonable for the identifier isn't the int
								end
								else begin
								        status<=`s15;//the identifier is int, everything comes to an end
								end
					 end
					 
					 /*`s8: begin
					         
					 end
					 
					 `s9:begin
					         if(in==";") begin
								        status<=`s14;
										  cnt<=0;
								end
					         if(in==" "||in=="	") begin
								        status<=`s9;
								end
								else if(in==",") begin
								        status<=`s4;
										  cnt<=0;//the same logic as before, going into loop until the ;
								end
								else begin
								        status<=`s15;
								end
					 end*/
					 
					`s14: begin
					        cnt<=0;
							  if(in==" "||in=="	") begin
							          status<=`s0;
							  end
					        else if(in==";") begin
							          status<=`s0;
							  end
							  else if(in=="i") begin
							          status<=`s1;
							  end
							  else begin
							          status<=`s15;
							  end
					end
					 
					 `s15: begin
					         if(in==";") begin
								        status<=`s0;//a sentence ends and we can go back to first;
										  cnt<=0;
								end
								else begin
								        status<=`s15;//keep waiting for ;
										  cnt<=0;
								end
					 end
					 endcase
		  end
end
assign out=(status==`s14)?1:0;
endmodule
