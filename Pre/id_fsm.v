`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:45:35 08/27/2023 
// Design Name: 
// Module Name:    id_fsm 
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
module id_fsm(
    input [7:0] char,
    input clk,
    output reg out
   
    );
	  reg [3:0] last;
	 initial begin
	   out<=0;
		last<=4'b0010;//2 presents integer and 3 presents strings and 4 presents others
	 end
always@(posedge clk) begin
      if(char>="0"&&char<="9") begin
		   last<=4'b0010;
		end
		else if((char>="a"&&char<="z")||(char>="A"&&char<="Z")) begin
		       last<=4'b0011;
		end
		else begin
		    last<=4'b0100;
		end
       if(out==1) begin
						  if(char>="0"&&char<="9") begin
						          out<=1;
						  end
						  else begin
						       out<=0;
						  end
     end
	  else begin
	        if((char>="a"&&char<="z")||(char>="A"&&char<="Z")) begin
			      out<=0;
			  end
			  else if(char>="0"&&char<="9") begin
			       if(last==4'b0011) begin
					     out<=1;
					 end
					 else begin
					     out<=0;
					 end
			  end
       end
end
endmodule
