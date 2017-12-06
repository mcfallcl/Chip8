`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/29/2017 02:55:39 PM
// Design Name:
// Module Name: Memory
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


module Memory(
    input clk,  // 25Mhz
    input [11:0] readwrite_address,
    input [7:0] write_value,
    input [11:0] read_address,
    input write,
    output reg [7:0] readwrite_read_value,
    output reg [7:0] read_value);

    reg [7:0] main_memory [0:12'hFFF];

    always @(negedge clk) begin
        readwrite_read_value <= main_memory[readwrite_address];
        read_value <= main_memory[read_address];
        if (write)
            main_memory[readwrite_address] <= write_value;
    end
endmodule
