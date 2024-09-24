`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:04:13 08/30/2023 
// Design Name: 
// Module Name:    cpu_checker 
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
`define s0 8'b0
`define s1 8'b1
`define s2 8'b10
`define s3 8'b11
`define s4 8'b100
`define s5 8'b101//register
`define s6 8'b110//memory
`define s7 8'b111
`define s8 8'b1000
`define s9 8'b1001
`define s10 8'b1010
`define s11 8'b1011
`define s12 8'b1100
module cpu_checker(
    input clk,
    input reset,
    input [7:0] char,
    output [1:0] format_type
    );
reg [7:0] status;//fsm records the status;
reg [7:0] number_cnt;
reg [7:0] char_cnt;
initial begin
status<=`s0;//original value;
number_cnt<=0;
char_cnt<=0;
end

always@(posedge clk) begin
        if(reset==1) begin
		          status<=`s0;
					 number_cnt<=0;
					 char_cnt<=0;
		  end
		  else begin
        case(status) 
		        `s0:begin//`s0 presents none effective inputs;
				          if(char=="^") begin
							         status<=`s1;
							 end
							 else begin
							       status<=`s0;
									 number_cnt<=0;
									 char_cnt<=0;
							 end
				  end
				  
				  `s1:begin//`s1 represents the position after s0 before @;
				          if(char>="0"&&char<="9") begin//inputs are decimal numbers
							         if(number_cnt==4) begin// decimal counter >= 4;
										        status<=`s0;
												  number_cnt<=0;
												  char_cnt<=0;
										end
										else begin// decimal >=1 && <= 4;
										        number_cnt<=number_cnt+1;
												  status<=`s1;
										end
							 end
							 else if(char=="@") begin
							         if(number_cnt==0) begin// have no numbers;
										        status<=`s0;
										end
										else begin
							         status<=`s2;
										number_cnt<=0;
										char_cnt<=0;
										end
							 end
							 else begin
							         status<=`s0;
										number_cnt<=0;
										char_cnt<=0;
							 end
				  end
				  
				  `s2:begin// hex pc;
				          if(char==":") begin
							         if(number_cnt+char_cnt==8) begin
										        status<=`s4;
												  number_cnt<=0;
												  char_cnt<=0;
										end
										else begin
										        status<=`s0;
												  number_cnt<=0;
												  char_cnt<=0;
										end
							 end
				          else if((char>="0"&&char<="9")||(char>="a"&&char<="f")) begin
							         if(number_cnt+char_cnt==8) begin
										         status<=`s0;
													number_cnt<=0;
													char_cnt<=0;
								     end
									  else begin
									        if(char>="0"&&char<="9") begin
											          number_cnt<=number_cnt+1;
														 status<=`s2;
											  end
											  else begin
											          char_cnt<=char_cnt+1;
														 status<=`s2;
											  end
									  end
							end
							else begin
							        status<=`s0;
									  number_cnt<=0;
									  char_cnt<=0;
							end
					end
					
					/*`s3: begin
					        if(char==":") begin
							          status<=`s4;
										 format_type<=2'b00;
							  end
							  else begin
							          status<=`s0;
										 format_type<=2'b00;
							  end
					end*  wrong logic*/
					
					`s4:begin
					        if(char==" ") begin
							          status<=`s4;
							  end
							  else if(char=="$") begin
							          status<=`s5;//register
							  end
							  else if(char=="*") begin
							          status<=`s6;//memory
							  end
							  else begin
							          status<=`s0;
							  end
					end
					
					`s5:begin//register
					        if(char>="0"&&char<="9") begin
							          if(number_cnt==4) begin
										         status<=`s0;
													number_cnt<=0;
										 end
										 else begin
										         status<=`s5;
													number_cnt<=number_cnt+1;
										 end
							  end
							  else if(char==" ")begin//possible wrong: not consider number after blank;
							          if(number_cnt==0) begin
										         status<=`s0;
										 end
										 else begin
							          status<=`s5;
										 end
							  end
							  else if(char=="<") begin
							          if(number_cnt==0) begin
										          status<=`s0;
										 end
										 else begin
							          status<=`s7;
										 number_cnt<=0;
										 end
							  end
							  else begin
							          status<=`s0;
										 number_cnt<=0;
							  end
					end
					
					`s6:begin//memory
					        if(char==" ") begin
							          if(number_cnt+char_cnt==8) begin
										         status<=`s6;
										 end
										 else begin
										         status<=`s0;
													number_cnt<=0;
													char_cnt<=0;
										 end
							  end
							   else if((char>="0"&&char<="9")||(char>="a"&&char<="f")) begin
							          if(number_cnt+char_cnt==8) begin
										         status<=`s0;
													number_cnt<=0;
													char_cnt<=0;
										 end
										 else begin
										         if(char>="0"&&char<="9") begin
													        number_cnt<=number_cnt+1;
															  status<=`s6;
													end
													else begin
													        char_cnt=char_cnt+1;
															  status<=`s6;
													end
					end
				end
				else if(char=="<") begin
							          if(number_cnt+char_cnt==8) begin
													 status<=`s9;
										 number_cnt<=0;
										 char_cnt<=0;
										 end
										 else begin
							           status<=`s0;
										 end
							  end
							  else begin
							          status<=`s0;
										 number_cnt<=0;
										 char_cnt<=0;
							  end
			end
			
			
					`s7: begin
					        if(char=="=") begin
							          status<=`s8;
							  end
							  else begin
							          status<=`s0;
							  end
					end
					
					`s8:begin
					        if(char==" ") begin
							          if(number_cnt==0) begin
							          status<=`s8;
										 end
										 else begin
										         status<=`s0;
													number_cnt<=0;
										 end
							  end
							  else if((char>="0"&&char<="9")||(char>="a"&&char<="f")) begin
							          if(number_cnt+char_cnt==8) begin
										         status<=`s0;
													number_cnt<=0;
													char_cnt<=0;
										 end
										 else begin
										         if(char>="0"&&char<="9") begin
													        number_cnt<=number_cnt+1;
															  status<=`s8;
													end
													else begin
													        char_cnt=char_cnt+1;
															  status<=`s8;
													end
										 end
							  end
							  else if(char=="#") begin
							          if(number_cnt+char_cnt==8) begin
													status<=`s0;//reset;
													status<=`s11;
													number_cnt<=0;
													char_cnt<=0;
										 end
										 else begin
										         status<=`s0;
													number_cnt<=0;
													char_cnt<=0;
										 end
							  end
							  else begin
							          status<=`s0;
										 number_cnt<=0;
										 char_cnt<=0;
							  end
					end
					
					`s9:begin
					        if(char=="=") begin
							          status<=`s10;
							  end
							  else begin
							          status<=`s0;
							  end
					end
					
					`s10:begin
					        if(char==" ") begin
							          if(number_cnt==0) begin
							          status<=`s10;
										 end
										 else begin
										         status<=`s0;
													number_cnt<=0;
										 end
							  end
							  else if((char>="0"&&char<="9")||(char>="a"&&char<="f")) begin
							          if(number_cnt+char_cnt==8) begin
										         status<=`s0;
													number_cnt<=0;
													char_cnt<=0;
										 end
										 else begin
										         if(char>="0"&&char<="9") begin
													        number_cnt<=number_cnt+1;
															  status<=`s10;
													end
													else begin
													        char_cnt=char_cnt+1;
															  status<=`s10;
													end
										 end
							  end
							  else if(char=="#") begin
							          if(number_cnt+char_cnt==8) begin
													status<=`s12;//reset;
													number_cnt<=0;
													char_cnt<=0;
										 end
										 else begin
										         status<=`s0;
													number_cnt<=0;
													char_cnt<=0;
										 end
							  end
							  else begin
							          status<=`s0;
										 number_cnt<=0;
										 char_cnt<=0;
							  end
					end
					
					`s11: begin
					        if(char=="^") begin
							          status<=`s1;
							  end
							  else begin
							          status<=`s0;
							  end
					end
					
					`s12: begin
					        if(char=="^") begin
							          status<=`s1;
							  end
							  else begin
							          status<=`s0;
							  end
					end
        endcase
		  end
end

assign format_type=(status==`s11)? 2'b01:
                                        (status==`s12)? 2'b10:
													 2'b00;
endmodule
