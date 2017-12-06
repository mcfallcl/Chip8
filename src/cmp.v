`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/18/2017 11:27:24 AM
// Design Name:
// Module Name: cmp
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


module Compare (
    input [7:0] a,
    input [7:0] b,
    output out,
    output out_bar);

    assign out = a == b;
    assign out_bar = ~out;
endmodule
