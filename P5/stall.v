`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:18:37 11/09/2023 
// Design Name: 
// Module Name:    stall 
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
module Stall(
    input [1:0]D_Tuse_rs,
	 input [1:0]D_Tuse_rt,
	 input [1:0] E_Tnew,
	 input [1:0] M_Tnew,
	 input [4:0]D_A1,
	 input [4:0]D_A2,
	 input [4:0]E_A3,
	 input [4:0]M_A3,
	 input HILO_operation,
	 input Busy,
	 input E_Start,
	 output stall
    );
wire E_stall_rs = (D_Tuse_rs<E_Tnew)&&(E_A3!=5'b0)&&(D_A1==E_A3);
wire E_stall_rt = (D_Tuse_rt<E_Tnew)&&(E_A3!=5'b0)&&(D_A2==E_A3);
wire M_stall_rs = (D_Tuse_rs<M_Tnew)&&(M_A3!=5'b0)&&(D_A1==M_A3);
wire M_stall_rt = (D_Tuse_rt<M_Tnew)&&(M_A3!=5'b0)&&(D_A2==M_A3);
wire HILO_stall = (HILO_operation&&(Busy|E_Start));
assign stall = (E_stall_rs)|(E_stall_rt)|(M_stall_rs)|(M_stall_rt)|(HILO_stall);

endmodule
