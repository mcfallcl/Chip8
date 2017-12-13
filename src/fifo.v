module FIFO (
    input clk,
    input read,
    input write,
    input [19:0] in,
    output empty,
    output full,
    output reg ERR = 0,         // read on empty or write on full
    output [19:0] out);

    reg [19:0] data [0:15];     // fist 12 for address, 8 for data
    reg [3:0] read_ptr = 0;     // points to the first item in the buffer
    reg [3:0] write_ptr = 0;    // points to the next slot in the buffer
    reg [19:0] out_data = 0;
    reg buffer_full = 0;
    reg buffer_empty = 1;

    assign full = buffer_full;
    assign empty = buffer_empty;
    assign out = out_data;

    always @(posedge clk) begin
        case ({ read, write })
            2'b01: begin
                if (full)
                    ERR <= 1;
                else begin
                    data[write_ptr] <= in;
                    write_ptr <= write_ptr + 1;
                    buffer_empty <= 0;
                    if (write_ptr + 1 == read_ptr)
                        buffer_full <= 1;
                    else
                        buffer_full <= 0;
                end
            end
            2'b10: begin
                if (empty)
                    ERR <= 1;
                else begin
                    out_data <= data[read_ptr];
                    read_ptr <= read_ptr + 1;
                    buffer_full <= 0;
                    if (read_ptr + 1 == write_ptr)
                        buffer_empty <= 1;
                    else
                        buffer_empty <= 0;
                end
            end
            2'b11: begin
                if (empty) begin
                    // pass it through to not miss a cycle
                    out_data <= in;
                end
                else begin
                    out_data <= data[read_ptr];
                    read_ptr <= read_ptr + 1;
                    data[write_ptr] <= in;
                    write_ptr <= write_ptr + 1;
                end
            end
        endcase
    end
endmodule