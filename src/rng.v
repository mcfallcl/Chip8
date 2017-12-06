`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/18/2017 11:50:31 AM
// Design Name:
// Module Name: rng
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


module RNG (
    input SYS_CLK,
    output [7:0] number);

    reg [7:0] num = 0;
    assign number = num;

    always @(posedge SYS_CLK)
        num <= num + 13;
endmodule
