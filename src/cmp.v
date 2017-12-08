// Compares two 8-bit numbers and outputs if they're equal or not.

module Compare (
    input [7:0] a,
    input [7:0] b,
    output out,
    output out_bar);

    assign out = a == b;
    assign out_bar = ~out;
endmodule
