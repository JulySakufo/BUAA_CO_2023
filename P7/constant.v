`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:36:58 11/23/2023 
// Design Name: 
// Module Name:    constant 
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
`define ADD_FUNCT 6'b100000
`define SUB_FUNCT 6'b100010
`define AND_FUNCT 6'b100100
`define OR_FUNCT 6'b100101
`define SLT_FUNCT 6'b101010
`define SLTU_FUNCT 6'b101011
`define JR_FUNCT 6'b001000
`define ADDU_FUNCT 6'b100001
`define NOP_FUNCT 6'b000000
`define MULT_FUNCT 6'b011000
`define MULTU_FUNCT 6'b011001
`define DIV_FUNCT 6'b011010
`define DIVU_FUNCT 6'b011011
`define MFHI_FUNCT 6'b010000
`define MFLO_FUNCT 6'b010010
`define MTHI_FUNCT 6'b010001
`define MTLO_FUNCT 6'b010011
`define SYSCALL_FUNCT 6'b001100
`define R_TYPE 6'b000000

`define ORI 6'b001101
`define ADDI 6'b001000
`define ANDI 6'b001100
`define LUI 6'b001111

`define LW 6'b100011
`define LH 6'b100001
`define LB 6'b100000
`define SW 6'b101011
`define SH 6'b101001
`define SB 6'b101000

`define BEQ 6'b000100
`define BNE 6'b000101
`define JAL 6'b000011
//`define J 6'b000010






