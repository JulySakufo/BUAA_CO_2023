`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:58:29 10/11/2023 
// Design Name: 
// Module Name:    BlockChecker 
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
`define s10 10
`define s11 11
`define s12 12
`define s13 13
`define s14 14
`define s15 15

module BlockChecker(
    input clk,
    input reset,
    input [7:0] in,
    output reg result
    );
reg [3:0] status;
reg [31:0] stack;
initial begin
        status<=`s0;
		  stack<=0;
		  result<=1;
end
always@(posedge clk or posedge reset) begin
        if(reset==1) begin
		          status<=`s0;//reset and empty all;
					 stack<=0;
					 result<=1;
		  end
		  else begin
		          case(status)
					 `s0: begin //at first or after blank
					         if(in=="b"||in=="B") begin
								        status<=`s1;
								end
								else if(in=="e"||in=="E") begin
								        status<=`s6;
								end
								else if(in==" ") begin
								        status<=`s0;
								end
								else begin
								        status<=`s11;//don't care other word;
								end
					 end
					 
					 `s1: begin//the first is b or B
					         if(in=="e"||in=="E") begin
								        status<=`s2;
								end
								else if(in==" ") begin
								        status<=`s0;//a word have been read and we should come back
								end
								else begin
								        status<=`s11;//don't care other word;
								end
					 end
					 
					 `s2:begin
					         if(in=="g"||in=="G") begin
								        status<=`s3;
								end
								else if(in==" ") begin
								        status<=`s0;
								end
								else begin
								        status<=`s11;
								end
					 end
					 
					 `s3:begin
					         if(in=="i"||in=="I") begin
								        status<=`s4;
								end
								else if(in==" ") begin
								        status<=`s0;
								end
								else begin
								         status<=`s11;
								end
					 end
					 
					 `s4: begin
					         if(in=="n"||in=="N") begin
								        status<=`s5;
										  //if(stack==0) begin//consider begin ... end begin,before begin result is always 1
										          result<=0;
										  //end
								end
								else if(in==" ") begin
								        status<=`s0;
								end
								else begin
								        status<=`s11;
								end
					 end
					 
					 `s5:begin//have read begin but not sure whether is begin
					         if(in==" ") begin//is begin and save into stack;
								        status<=`s0;
										  stack<=stack+1;
								end
								else begin//other word and we don't care
								        status<=`s11;
										  if(stack==0) begin//once stack==0,result=1;
										          result<=1;
										  end
								end
					 end
					 
					 `s6:begin//the first is e or E
					         if(in=="n"||in=="N") begin
								        status<=`s7;
								end
								else if(in==" ") begin
								        status<=`s0;
								end
								else begin
								        status<=`s11;
								end
					 end
					 
					 `s7: begin//have read en
					         if(in=="d"||in=="D") begin
								        status<=`s8;
										  if(stack==1) begin
										          result<=1;
										  end
										  else begin
										          result<=0;
										  end
								end
								else if(in==" ") begin
								        status<=`s0;
								end
								else begin
								        status<=`s11;
								end
					 end
					 
					 `s8: begin//have read end but not sure whether is end
					         if(in==" ") begin//is en
										          if(stack==0) begin
								                   status<=`s12;//out always is 0 and we should wait until reset
								            end
								                else begin
										             status<=`s0;
														 stack<=stack-1;//match a begin and delete a begin;
										  end
								end
								else begin//is not end, don't care other word
								        if(stack==0) begin/*tb:endc endc*/
										          result<=1;
										  end
										  else begin/*solve four wrong point*/    /*tb: a begin endc*/
										        result<=0;
										  end
								        status<=`s11;
								end
					 end
					 
					 `s11: begin
					         if(in==" ") begin// a word have been read,a new word should be read
								        status<=`s0;
								end
								else begin
								        status<=`s11;
								end
					 end
					 
					 `s12: begin//wrong match,end > begin;
					 status<=`s12;
					 result<=0;
					 end
					 endcase
		  end
end
endmodule
