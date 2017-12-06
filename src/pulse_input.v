

module InputPulse (
    input clk,
    input [15:0] in,
    output reg [15:0] out);

    reg [15:0] old = 0;
    reg [15:0] new = 0;

    always @(posedge clk) begin
        new <= in;
        old <= new;
        out <= (~old & new);
    end
endmodule