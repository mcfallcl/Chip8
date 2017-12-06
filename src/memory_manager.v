

module MemoryManager (
    input clk,
    input write_enable,
    input [3:0] write_count,
    input [127:0] write_buffer,
    input [11:0] address,
    input [11:0] pc,
    input [5:0] address_counter,
    output [127:0] read_buffer,
    output reg [15:0] opcode);

    reg [7:0] write_data = 0;
    wire [7:0] read_data;

    reg [7:0] read [15:0];
    wire [7:0] write [15:0];

    assign read_buffer[127:120] = read[15];
    assign read_buffer[119:112] = read[14];
    assign read_buffer[111:104] = read[13];
    assign read_buffer[103:96] = read[12];
    assign read_buffer[95:88] = read[11];
    assign read_buffer[87:80] = read[10];
    assign read_buffer[79:72] = read[9];
    assign read_buffer[71:64] = read[8];
    assign read_buffer[63:56] = read[7];
    assign read_buffer[55:48] = read[6];
    assign read_buffer[47:40] = read[5];
    assign read_buffer[39:32] = read[4];
    assign read_buffer[31:24] = read[3];
    assign read_buffer[23:16] = read[2];
    assign read_buffer[15:8] = read[1];
    assign read_buffer[7:0] = read[0];

    assign write[0] = write_buffer[7:0];
    assign write[1] = write_buffer[15:8];
    assign write[2] = write_buffer[23:16];
    assign write[3] = write_buffer[31:24];
    assign write[4] = write_buffer[39:32];
    assign write[5] = write_buffer[47:40];
    assign write[6] = write_buffer[55:48];
    assign write[7] = write_buffer[63:56];
    assign write[8] = write_buffer[71:64];
    assign write[9] = write_buffer[79:72];
    assign write[10] = write_buffer[87:80];
    assign write[11] = write_buffer[95:88];
    assign write[12] = write_buffer[103:96];
    assign write[13] = write_buffer[111:104];
    assign write[14] = write_buffer[119:112];
    assign write[15] = write_buffer[127:120];

    reg [11:0] a = 0;
    //assign a = address + address_counter[3:0];

    wire[7:0] dpo;
    wire[11:0] program_counter;
    assign program_counter = pc + address_counter[0];

    wire we;
    wire write_valid;
    assign we = write_enable && write_valid;
    assign write_valid = (address_counter[3:0] <= write_count) && (address_counter < 16);

    dist_mem_gen_0 main_memory (
        .a(a),
        .d(write_data),
        .dpra(program_counter),
        .clk(clk),
        .we(we),
        .spo(read_data),
        .dpo(dpo));

    //blk_mem_gen_0 main_memory (
    //    .clka(clk),
    //    .ena(1),
    //    .wea(write_enable),
    //    .addra(a),
    //    .dina(write_data),
    //    .douta(read_data),
    //    .clkb(clk),
    //    .enb(1),
    //    .web(0),
    //    .addrb(program_counter),
    //    .dinb(0),
    //    .doutb(dpo));

    wire [3:0] mem_offset;
    assign mem_offset = address_counter[3:0] - 1;
    always @(posedge clk) begin
        //address_offset = address_counter - 2;
        read[mem_offset] <= read_data;
        a <= address + address_counter[3:0];

        if (address_counter[0])
            opcode[7:0] <= dpo;
        else
            opcode[15:8] <= dpo;

        write_data <= write[address_counter[3:0]];
    end

endmodule
