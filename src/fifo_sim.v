module fifo_sim ();

    reg clk = 0;
    reg read = 0;
    reg write = 0;
    reg [19:0] in = 0;

    wire empty;
    wire full;
    wire ERR;
    wire [19:0] out;

    FIFO fifo (
        .clk(clk),
        .read(read),
        .write(write),
        .in(in),
        .empty(empty),
        .full(full),
        .ERR(ERR),
        .out(out));

    always begin
        #1 clk = ~clk;
    end

    initial begin
        repeat(15) begin
            #2;
            write <= 1;
            in <= in + 1;
            #2 write <= 0;
        end
        repeat(12) begin
            #2;
            read <= 1;
            #2 read <= 0;
        end
        repeat(4) begin
            #2;
            write <= 1;
            in <= in + 1;
            #2 write <= 0;
        end
        repeat(7) begin
            #2;
            read <= 1;
            #2 read <= 0;
        end
        #200;
        write <= 1;
        in <= in + 1;
        repeat(16) begin
            #2;
            in <= in + 1;
        end
        write <= 0;
        #2;
        read <= 1;
        repeat(16) begin
            #2;
            // nothing
        end
        read <= 0;
        #200;
        $finish;
    end

endmodule