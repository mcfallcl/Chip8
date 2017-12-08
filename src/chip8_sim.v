
module chip8_sim (
    );

    reg clk = 0;
    reg BTNR = 0;
    reg BTNL = 0;
    reg BTNU = 0;
    reg BTND = 0;
    reg BTNC = 0;
    reg [15:0] inputs = 0;

    wire [15:0] LED;
    wire VGA_HS;
    wire VGA_VS;
    wire [3:0] VGA_R;
    wire [3:0] VGA_G;
    wire [3:0] VGA_B;
    wire LED16_R;
    wire LED17_R;

    wire [11:0] pc;
    wire [15:0] op;
    wire [7:0] guess_data;
    wire [7:0] spo;
    wire [11:0] i;
    wire [127:0] regs;
    wire [7:0] registers [0:15];
    wire [127:0] readout;
    wire [7:0] mem_read [0:15];
    wire [0:2047] flat_video_memory;
    wire [0:63] video_memory [0:31];
    wire vidclear;

    assign video_memory[0] = flat_video_memory[0:63];
    assign video_memory[1] = flat_video_memory[64:127];
    assign video_memory[2] = flat_video_memory[128:191];
    assign video_memory[3] = flat_video_memory[192:255];
    assign video_memory[4] = flat_video_memory[256:319];
    assign video_memory[5] = flat_video_memory[320:383];
    assign video_memory[6] = flat_video_memory[384:447];
    assign video_memory[7] = flat_video_memory[448:511];
    assign video_memory[8] = flat_video_memory[512:575];
    assign video_memory[9] = flat_video_memory[576:639];
    assign video_memory[10] = flat_video_memory[640:703];
    assign video_memory[11] = flat_video_memory[704:767];
    assign video_memory[12] = flat_video_memory[768:831];
    assign video_memory[13] = flat_video_memory[832:895];
    assign video_memory[14] = flat_video_memory[896:959];
    assign video_memory[15] = flat_video_memory[960:1023];
    assign video_memory[16] = flat_video_memory[1024:1087];
    assign video_memory[17] = flat_video_memory[1088:1151];
    assign video_memory[18] = flat_video_memory[1152:1215];
    assign video_memory[19] = flat_video_memory[1216:1279];
    assign video_memory[20] = flat_video_memory[1280:1343];
    assign video_memory[21] = flat_video_memory[1344:1407];
    assign video_memory[22] = flat_video_memory[1408:1471];
    assign video_memory[23] = flat_video_memory[1472:1535];
    assign video_memory[24] = flat_video_memory[1536:1599];
    assign video_memory[25] = flat_video_memory[1600:1663];
    assign video_memory[26] = flat_video_memory[1664:1727];
    assign video_memory[27] = flat_video_memory[1728:1791];
    assign video_memory[28] = flat_video_memory[1792:1855];
    assign video_memory[29] = flat_video_memory[1856:1919];
    assign video_memory[30] = flat_video_memory[1920:1983];
    assign video_memory[31] = flat_video_memory[1984:2047];

    assign registers[0] = regs[7:0];
    assign registers[1] = regs[15:8];
    assign registers[2] = regs[23:16];
    assign registers[3] = regs[31:24];
    assign registers[4] = regs[39:32];
    assign registers[5] = regs[47:40];
    assign registers[6] = regs[55:48];
    assign registers[7] = regs[63:56];
    assign registers[8] = regs[71:64];
    assign registers[9] = regs[79:72];
    assign registers[10] = regs[87:80];
    assign registers[11] = regs[95:88];
    assign registers[12] = regs[103:96];
    assign registers[13] = regs[111:104];
    assign registers[14] = regs[119:112];
    assign registers[15] = regs[127:120];

    assign mem_read[0] = readout[7:0];
    assign mem_read[1] = readout[15:8];
    assign mem_read[2] = readout[23:16];
    assign mem_read[3] = readout[31:24];
    assign mem_read[4] = readout[39:32];
    assign mem_read[5] = readout[47:40];
    assign mem_read[6] = readout[55:48];
    assign mem_read[7] = readout[63:56];
    assign mem_read[8] = readout[71:64];
    assign mem_read[9] = readout[79:72];
    assign mem_read[10] = readout[87:80];
    assign mem_read[11] = readout[95:88];
    assign mem_read[12] = readout[103:96];
    assign mem_read[13] = readout[111:104];
    assign mem_read[14] = readout[119:112];
    assign mem_read[15] = readout[127:120];

    Chip8 chip (
        .SYS_CLK(clk),
        .BTNR(BTNR),
        .BTNL(BTNL),
        .BTNU(BTNU),
        .BTND(BTND),
        .BTNC(BTNC),
        .SW(inputs),
        .LED(LED),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .LED16_R(LED16_R),
        .LED17_R(LED17_R),
        .pc(pc),
        .op(op),
        .g_data(guess_data),
        .spo(spo),
        .i(i),
        .regs(regs),
        .readout(readout),
        .vidout(flat_video_memory),
        .vidclear(vidclear));

    always begin
        #1 clk = ~clk;
    end

    initial begin
        #40000 BTNR = 1;
        #4000 BTNR = 0;
        #500000000;
        $finish;
    end

endmodule
