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
	 input [15:0] freq,
	 output [3:0] error_code,
    output [1:0] format_type
    );
	 reg x1;
	 reg x2;
	 reg [15:0] temp;
	 reg [15:0]stdtime;//left shift considers the bits;
reg [7:0] status;//fsm records the status;
reg [7:0] number_cnt;
reg [7:0] char_cnt;
reg [31:0] timesum;//time number;
reg [31:0] pc;
reg [31:0] addr;
reg [7:0] grf;
reg time_checker;
reg pc_checker;
reg addr_checker;
reg grf_checker;
integer i;
initial begin
status<=`s0;//original value;
number_cnt<=0;
char_cnt<=0;
timesum<=0;//bit multiplier;10 means (<<3)+(<<1);
pc<=0;
addr<=0;
grf<=0;
time_checker<=1;
pc_checker<=1;
addr_checker<=1;
grf_checker<=1;//1 means wrong,0 means correct;
x1<=0;
x2<=0;
stdtime<=0;
i=0;
end

always@(posedge clk) begin
        if(reset==1) begin
		          status<=`s0;
					 number_cnt<=0;
					 char_cnt<=0;
					 time_checker<=1;
                                        pc_checker<=1;
                                        addr_checker<=1;
                                        grf_checker<=1;
		  end
		  else begin
        case(status) 
		        `s0:begin//`s0 presents none effective inputs;
				          if(char=="^") begin
							         status<=`s1;//only change the position;
										number_cnt<=0;
										char_cnt<=0;
										timesum<=0;
										pc<=0;
										addr<=0;
										grf<=0;// the position the reset;
										time_checker<=1;
                                        pc_checker<=1;
                                        addr_checker<=1;
                                        grf_checker<=1;
							 end
							 else begin
							       status<=`s0;
									 number_cnt<=0;
									 char_cnt<=0;
									 timesum<=0;// go back to original;
									 pc<=0;
									 addr<=0;
									 grf<=0;// the position the reset;
									 time_checker<=1;
                                     pc_checker<=1;
                                     addr_checker<=1;
                                     grf_checker<=1;
							 end
				  end
				  
				  `s1:begin//`s1 represents the position after s0 before @;
				          if(char>="0"&&char<="9") begin//inputs are decimal numbers
							         if(number_cnt==4) begin// decimal counter >= 4;
										        status<=`s0;
												  number_cnt<=0;
												  char_cnt<=0;
												  timesum<=0;
										end
										else begin// decimal >=1 && <= 4;
										        number_cnt<=number_cnt+1;
												  status<=`s1;
												  timesum<=(timesum<<3)+(timesum<<1)+char-"0";//ascii-"0" means number;// prepare to check the time whether is legal;
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
														 pc=(pc<<4)+char-"0";
											  end
											  else begin
											          char_cnt<=char_cnt+1;
														 status<=`s2;
														 pc<=(pc<<4)+char-"a"+10;
											  end
									  end
							end
							else begin
							        status<=`s0;
									  number_cnt<=0;
									  char_cnt<=0;
							end
					end
					
					
					`s4:begin
					        if(char==" ") begin
							          status<=`s4;
							  end
							  else if(char=="$") begin
							          status<=`s5;//register
							  end
							  else if(char==8'd42) begin
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
													grf<=(grf<<3)+(grf<<1)+char-"0";
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
															  addr<=(addr<<4)+char-"0";
													end
													else begin
													        char_cnt=char_cnt+1;
															  status<=`s6;
															  addr<=(addr<<4)+char-"a"+10;
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
							          if(number_cnt+char_cnt==0) begin
							          status<=`s8;
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
													status<=`s11;//find the register information;
													number_cnt<=0;
													char_cnt<=0;
													i=0;//timesum=10;
													stdtime=(freq>>1);//freq=100;
													if(timesum>=(freq>>1)) begin//only when time sum> (freq>>1), there happens a story;
												   while(stdtime!=0) begin//stdtime=10;i=2;
													        stdtime=stdtime>>1;
															  i=i+1;
													end
													for(;i>0;i=i-1) begin
													        if(timesum[i-1]>freq[i]) begin
															          time_checker=0;
															  end
													end
													if(time_checker==1) begin
													        time_checker=0;
													end
													else begin
													        time_checker=1;
													end
													end
													if(timesum==0) begin
													        time_checker=0;//special judge;
													end
													if(pc>=32'h00003000&&pc<=32'h00004fff) begin//check whether the pc is legal; wrong reason: judge the 4;
													       x1=pc[0];
															 x2=pc[1];
															 if(x1==0&&x2==0) begin
															         pc_checker<=0;
															 end
															 x1=0;
															 x2=0;
													end
													
													if(grf>=0&&grf<=31) begin//check whether the grf is legal;
													        grf_checker<=0;
													end
													addr_checker<=0;
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
							          if(number_cnt+char_cnt==0) begin
							          status<=`s10;
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
													stdtime=(freq>>1);
													if(timesum>=(freq>>1)) begin//only when time sum> (freq>>1), there happens a story;
												   while(stdtime!=0) begin//stdtime=10;i=2;
													        stdtime=stdtime>>1;
															  i=i+1;
													end
													for(;i>0;i=i-1) begin
													        if(timesum[i-1]>freq[i]) begin
															          time_checker=0;
															  end
													end
													if(time_checker==1) begin
													        time_checker=0;
													end
													else begin
													        time_checker=1;
													end
													end
													if(timesum==0) begin
													        time_checker=0;
													end
													if(pc>=32'h00003000&&pc<=32'h00004fff) begin//check whether the pc is legal;
													        x1=pc[0];
															 x2=pc[1];
															 if(x1==0&&x2==0) begin
															         pc_checker<=0;
															 end
															 x1=0;
															 x2=0;
													end
													
													if(addr>=32'h00000000&&addr<=32'h00002fff) begin//check whether the addr is legal; wrong reason: judge the 4;
													if(addr>=4) begin
													       x1=addr[0];
															 x2=addr[1];
															 if(x1==0&&x2==0) begin
															         addr_checker<=0;
															 end
															 x1=0;
															 x2=0;
												end
													end
													if(addr==0) begin
													        addr_checker=0;
													end
													grf_checker<=0;
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
							          number_cnt<=0;
										char_cnt<=0;
										timesum<=0;
										pc<=0;
										addr<=0;
										grf<=0;// the position the reset;
										time_checker<=1;
                                        pc_checker<=1;
                                        addr_checker<=1;
                                        grf_checker<=1;
							  end
							  else begin
							          status<=`s0;
							  end
					end
					
					`s12: begin
					        if(char=="^") begin
							          status<=`s1;
							          number_cnt<=0;
										char_cnt<=0;
										timesum<=0;
										pc<=0;
										addr<=0;
										grf<=0;// the position the reset;
										time_checker<=1;
                                        pc_checker<=1;
                                        addr_checker<=1;
                                        grf_checker<=1;
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
assign error_code=(status!=`s11&&status!=`s12)?4'b0000:
(time_checker==1&&pc_checker==1&&grf_checker==1&&addr_checker==1)? 4'b0000://unless assign again;
                                       (time_checker==1&&pc_checker==1&&grf_checker==1)? 4'b1011:
                                      (time_checker==1&&pc_checker==1&&addr_checker==1)? 4'b0111://7;
												  (time_checker==1&&pc_checker==1)? 4'b0011://3;
												  (time_checker==1&&grf_checker==1)? 4'b1001:
												  (pc_checker==1&&grf_checker==1)? 4'b1010:
												  (time_checker==1&&addr_checker==1)? 4'b0101:
												  (pc_checker==1&&addr_checker==1)? 4'b0110:
												  (time_checker==1)? 4'b0001://1;
												  (pc_checker==1)?4'b0010://2;
												  (addr_checker==1)? 4'b0100:
												  (grf_checker==1)? 4'b1000:
												  4'b0000;
endmodule
