`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/18/2017 11:35:58 AM
// Design Name:
// Module Name: opcode_decoder
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module OpcodeDecoder (
    input [15:0] opcode,
    output [3:0] leader,
    output [3:0] rx,
    output [3:0] ry,
    output [3:0] nibble,
    output [7:0] const,
    output [11:0] address);

    assign leader = opcode[15:12];
    assign rx = opcode[11:8];
    assign ry = opcode[7:4];
    assign nibble = opcode[3:0];
    assign const = opcode[7:0];
    assign address = opcode[11:0];
endmodule
