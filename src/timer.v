/*
 *
 */

module Timer (
    input SYS_CLK,
    input set,
    input [7:0] in,
    output [7:0] value,
    output signal);

    reg [7:0] timer_value = 0;
    assign value = timer_value;
    assign signal = timer_value > 0;

    parameter clk_limit = 833334;
    reg [19:0] clk_ctr_60hz = 0;
    reg clk_60hz = 0;
    reg old_clk_60hz = 0;

    always @(negedge SYS_CLK) begin
        old_clk_60hz <= clk_60hz;
        if (set)
            timer_value <= in;
        else if (clk_ctr_60hz < clk_limit)
            clk_ctr_60hz <= clk_ctr_60hz + 1;
        else begin
            clk_ctr_60hz <= 0;
            clk_60hz <= ~clk_60hz;
        end

        if (clk_60hz && !old_clk_60hz && timer_value > 0)
            timer_value <= timer_value - 1;
    end


endmodule
