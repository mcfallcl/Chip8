// converts switch inputs into what Chip-8 expects.

module InputHandler (
    input clk,
    input [15:0] inputs,
    output reg key_pressed,
    output reg [3:0] key_code);

    always @(posedge clk) begin
        case (inputs)
            16'h0001: begin
                key_code <= 0;
                key_pressed <= 1;
            end
            16'h0002: begin
                key_code <= 1;
                key_pressed <= 1;
            end
            16'h0004: begin
                key_code <= 2;
                key_pressed <= 1;
            end
            16'h0008: begin
                key_code <= 3;
                key_pressed <= 1;
            end
            16'h0010: begin
                key_code <= 4;
                key_pressed <= 1;
            end
            16'h0020: begin
                key_code <= 5;
                key_pressed <= 1;
            end
            16'h0040: begin
                key_code <= 6;
                key_pressed <= 1;
            end
            16'h0080: begin
                key_code <= 7;
                key_pressed <= 1;
            end
            16'h0100: begin
                key_code <= 8;
                key_pressed <= 1;
            end
            16'h0200: begin
                key_code <= 9;
                key_pressed <= 1;
            end
            16'h0400: begin
                key_code <= 10;
                key_pressed <= 1;
            end
            16'h0800: begin
                key_code <= 11;
                key_pressed <= 1;
            end
            16'h1000: begin
                key_code <= 12;
                key_pressed <= 1;
            end
            16'h2000: begin
                key_code <= 13;
                key_pressed <= 1;
            end
            16'h4000: begin
                key_code <= 14;
                key_pressed <= 1;
            end
            16'h8000: begin
                key_code <= 15;
                key_pressed <= 1;
            end
            default: begin
                key_pressed <= 0;
                key_code <= 16'hXXXX;
            end
        endcase
    end

endmodule
