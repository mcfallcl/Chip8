/*
 * Generates a random number
 */

module RNG (
    input SYS_CLK,
    output [7:0] number);

    reg [7:0] num = 0;
    assign number = num;

    always @(posedge SYS_CLK)
        num <= num + 13;
endmodule
