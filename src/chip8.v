
module Chip8(
    input SYS_CLK,
    input BTNR,
    input BTNL,
    input BTNU,
    input BTND,
    input BTNC,
    input [15:0] SW,
    output [15:0] LED,
    output VGA_HS,
    output VGA_VS,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output LED16_R,
    output LED17_R//,
    // remove before running on board, sim only
    //output [11:0] pc,
    //output [15:0] op,
    //output [7:0] g_data,
    //output [7:0] spo,
    //output [11:0] i,
    //output [127:0] regs,
    //output [127:0] readout,
    //output [0:2047] vidout,
    //output vidclear
    );

    //assign op = current_opcode;
    //assign pc = program_counter;
    //assign g_data = guess_data;
    //assign spo = read_buffer[1];
    //assign i = i_reg;
    //assign regs[127:120] = registers[15];
    //assign regs[119:112] = registers[14];
    //assign regs[111:104] = registers[13];
    //assign regs[103:96] = registers[12];
    //assign regs[95:88] = registers[11];
    //assign regs[87:80] = registers[10];
    //assign regs[79:72] = registers[9];
    //assign regs[71:64] = registers[8];
    //assign regs[63:56] = registers[7];
    //assign regs[55:48] = registers[6];
    //assign regs[47:40] = registers[5];
    //assign regs[39:32] = registers[4];
    //assign regs[31:24] = registers[3];
    //assign regs[23:16] = registers[2];
    //assign regs[15:8] = registers[1];
    //assign regs[7:0] = registers[0];
    //assign readout = read_out;
    //assign vidout = flat_video_memory;
    //assign vidclear = vid_clear;

    reg [11:0] rom_index = 0;
    wire [7:0] rom_data;

    reg [2:0] which_rom = 0;

    wire [7:0] guess_data;
    GUESS guess_rom (
        .a(rom_index),
        .spo(guess_data));

    wire [7:0] c4_data;
    CONNECT4 c4_rom (
        .a(rom_index),
        .spo(c4_data));

    wire [7:0] tictac_data;
    TICTAC tictac_rom (
        .a(rom_index),
        .spo(tictac_data));

    wire [7:0] puzzle_data;
    PUZZLE puzzle_rom (
        .a(rom_index),
        .spo(puzzle_data));

    wire [7:0] puzzle15_data;
    PUZZLE15 puzzle15_rom (
        .a(rom_index),
        .spo(puzzle15_data));

    assign rom_data = (which_rom == 0) ? guess_data :
                      (which_rom == 1) ? c4_data :
                      (which_rom == 2) ? puzzle_data :
                      (which_rom == 3) ? puzzle15_data :
                      (which_rom == 4) ? tictac_data : 0;

    reg ERR = 0;
    assign LED17_R = ERR;
    assign LED16_R = ERR;

    reg [5:0] clk_ctr = 0;
    reg Chip8CLK = 0;
    wire [15:0] user_inputs;
    InputPulse in_pulser (
        .clk(Chip8CLK),
        .in(SW),
        .out(user_inputs));

    wire [15:0] current_opcode;
    reg [7:0] registers [0:15];
    // programs always start at 0x200 in memory.
    reg [11:0] program_counter = 12'h200;
    //assign current_opcode[15:8] = main_memory[program_counter];
    //assign current_opcode[7:0] = main_memory[program_counter + 1];
    reg [11:0] i_reg = 0;
    // for operations that don't update i_reg, but use values around i_reg.
    //reg [11:0] temp_ireg = 0;
    reg [3:0] repeat_ctr = 0;

    reg [3:0] write_count = 0;
    wire [7:0] read_buffer [0:15];
    //reg [7:0] write_buffer [0:15];
    reg write_enable = 0;
    wire [127:0] read_out;
    wire [127:0] write_in;
    reg [7:0] write_buffer [0:15];
    MemoryManager main_memory (
        .clk(SYS_CLK),
        .write_enable(write_enable),
        .write_count(write_count),
        .write_buffer(write_in),
        .address(i_reg),
        .pc(program_counter),
        .address_counter(clk_ctr),
        .read_buffer(read_out),
        .opcode(current_opcode));

    assign read_buffer[0] = read_out[7:0];
    assign read_buffer[1] = read_out[15:8];
    assign read_buffer[2] = read_out[23:16];
    assign read_buffer[3] = read_out[31:24];
    assign read_buffer[4] = read_out[39:32];
    assign read_buffer[5] = read_out[47:40];
    assign read_buffer[6] = read_out[55:48];
    assign read_buffer[7] = read_out[63:56];
    assign read_buffer[8] = read_out[71:64];
    assign read_buffer[9] = read_out[79:72];
    assign read_buffer[10] = read_out[87:80];
    assign read_buffer[11] = read_out[95:88];
    assign read_buffer[12] = read_out[103:96];
    assign read_buffer[13] = read_out[111:104];
    assign read_buffer[14] = read_out[119:112];
    assign read_buffer[15] = read_out[127:120];

    assign write_in[127:120] = write_buffer[15];
    assign write_in[119:112] = write_buffer[14];
    assign write_in[111:104] = write_buffer[13];
    assign write_in[103:96] = write_buffer[12];
    assign write_in[95:88] = write_buffer[11];
    assign write_in[87:80] = write_buffer[10];
    assign write_in[79:72] = write_buffer[9];
    assign write_in[71:64] = write_buffer[8];
    assign write_in[63:56] = write_buffer[7];
    assign write_in[55:48] = write_buffer[6];
    assign write_in[47:40] = write_buffer[5];
    assign write_in[39:32] = write_buffer[4];
    assign write_in[31:24] = write_buffer[3];
    assign write_in[23:16] = write_buffer[2];
    assign write_in[15:8] = write_buffer[1];
    assign write_in[7:0] = write_buffer[0];

    // cheating using this instead of main memory
    reg [11:0] call_stack [0:31];
    reg [4:0] stack_pointer = 0;

    wire [3:0] op_leader;
    wire [3:0] rx_sel;
    wire [3:0] ry_sel;
    wire [3:0] op_nibble;
    wire [7:0] op_const;
    wire [11:0] op_address;
    OpcodeDecoder op_decoder (
        .opcode(current_opcode),
        .leader(op_leader),
        .rx(rx_sel),
        .ry(ry_sel),
        .nibble(op_nibble),
        .const(op_const),
        .address(op_address));

    //reg [7:0] main_memory [0:12'hFFF];


    assign LED[11:0] = program_counter;

    reg [8:0] alu_result = 0;
    //wire [7:0] alu_out;
    //wire alu_carry;
    //wire ALU_error = 0;
    //ALU alu (
    //    .clk(SYS_CLK),
    //    .op1(registers[rx_sel]),
    //    .op2(registers[ry_sel]),
    //    .opcode(current_opcode[3:0]),
    //    .out(alu_out),
    //    .carry(alu_carry),
    //    .ALU_ERR(ALU_error));

    // When register x and register y are equal, cmp_out is HIGH. Else
    // it is LOW. cmp_outbar is always the opposite of cmp_out.
    wire cmp_out;
    wire cmp_outbar;
    Compare cmp (
        .a(registers[rx_sel]),
        .b(registers[ry_sel]),
        .out(cmp_out),
        .out_bar(cmp_outbar));

    // randomly generated number. When a random number is
    // requested, put this number into a register.
    wire [7:0] random_number;
    RNG rng (
        .SYS_CLK(SYS_CLK),
        .number(random_number));

    wire [7:0] delay_value;
    reg [7:0] delay_in = 0;
    reg delay_set = 0;
    Timer delay_timer (
        .SYS_CLK(SYS_CLK),
        .set(delay_set),
        .in(delay_in),
        .value(delay_value),
        .signal(delay_signal));

    wire [7:0] audio_value;
    reg [7:0] audio_in = 0;
    reg audio_set = 0;
    Timer audio_timer (
        .SYS_CLK(SYS_CLK),
        .set(audio_set),
        .in(audio_in),
        .value(audio_value),
        .signal(audio_signal));

    wire key_pressed;
    wire [3:0] key_code;
    InputHandler input_handler (
        .clk(SYS_CLK),
        .inputs(user_inputs),
        .key_pressed(key_pressed),
        .key_code(key_code));

    parameter screen_height = 32;
    parameter screen_width = 64;
    // reversed to make converting much easier.
    wire [0:2047] flat_video_memory;

    reg [0:70] video_memory [0:31];

    assign flat_video_memory[0:63] = video_memory[0][0:63];
    assign flat_video_memory[64:127] = video_memory[1][0:63];
    assign flat_video_memory[128:191] = video_memory[2][0:63];
    assign flat_video_memory[192:255] = video_memory[3][0:63];
    assign flat_video_memory[256:319] = video_memory[4][0:63];
    assign flat_video_memory[320:383] = video_memory[5][0:63];
    assign flat_video_memory[384:447] = video_memory[6][0:63];
    assign flat_video_memory[448:511] = video_memory[7][0:63];
    assign flat_video_memory[512:575] = video_memory[8][0:63];
    assign flat_video_memory[576:639] = video_memory[9][0:63];
    assign flat_video_memory[640:703] = video_memory[10][0:63];
    assign flat_video_memory[704:767] = video_memory[11][0:63];
    assign flat_video_memory[768:831] = video_memory[12][0:63];
    assign flat_video_memory[832:895] = video_memory[13][0:63];
    assign flat_video_memory[896:959] = video_memory[14][0:63];
    assign flat_video_memory[960:1023] = video_memory[15][0:63];
    assign flat_video_memory[1024:1087] = video_memory[16][0:63];
    assign flat_video_memory[1088:1151] = video_memory[17][0:63];
    assign flat_video_memory[1152:1215] = video_memory[18][0:63];
    assign flat_video_memory[1216:1279] = video_memory[19][0:63];
    assign flat_video_memory[1280:1343] = video_memory[20][0:63];
    assign flat_video_memory[1344:1407] = video_memory[21][0:63];
    assign flat_video_memory[1408:1471] = video_memory[22][0:63];
    assign flat_video_memory[1472:1535] = video_memory[23][0:63];
    assign flat_video_memory[1536:1599] = video_memory[24][0:63];
    assign flat_video_memory[1600:1663] = video_memory[25][0:63];
    assign flat_video_memory[1664:1727] = video_memory[26][0:63];
    assign flat_video_memory[1728:1791] = video_memory[27][0:63];
    assign flat_video_memory[1792:1855] = video_memory[28][0:63];
    assign flat_video_memory[1856:1919] = video_memory[29][0:63];
    assign flat_video_memory[1920:1983] = video_memory[30][0:63];
    assign flat_video_memory[1984:2047] = video_memory[31][0:63];

    wire [10:0] video_index;
    reg [5:0] x_coords = 0;
    reg [4:0] y_coords = 0;
    assign video_index = y_coords * screen_width + x_coords;
    reg [10:0] display_ptr;
    Display display (
        .SYS_CLK(SYS_CLK),
        .flat_video_memory(flat_video_memory),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B));

    reg loading = 0;
    reg start_loading = 0;
    reg old_loading = 0;

    reg vid_clear = 0;
    reg vid_write = 0;
    reg [3:0] sprite_height = 0;
    reg [3:0] vid_counter = 0;
    reg write_begin = 0;
    reg write_finish = 0;
    always @(posedge SYS_CLK) begin
        if (clk_ctr < 63)
            clk_ctr <= clk_ctr + 1;
        else begin
            Chip8CLK <= ~Chip8CLK;
            clk_ctr <= 0;
        end
        if (vid_clear) begin
            video_memory[0] <= 0;
            video_memory[1] <= 0;
            video_memory[2] <= 0;
            video_memory[3] <= 0;
            video_memory[4] <= 0;
            video_memory[5] <= 0;
            video_memory[6] <= 0;
            video_memory[7] <= 0;
            video_memory[8] <= 0;
            video_memory[9] <= 0;
            video_memory[10] <= 0;
            video_memory[11] <= 0;
            video_memory[12] <= 0;
            video_memory[13] <= 0;
            video_memory[14] <= 0;
            video_memory[15] <= 0;
            video_memory[16] <= 0;
            video_memory[17] <= 0;
            video_memory[18] <= 0;
            video_memory[19] <= 0;
            video_memory[20] <= 0;
            video_memory[21] <= 0;
            video_memory[22] <= 0;
            video_memory[23] <= 0;
            video_memory[24] <= 0;
            video_memory[25] <= 0;
            video_memory[26] <= 0;
            video_memory[27] <= 0;
            video_memory[28] <= 0;
            video_memory[29] <= 0;
            video_memory[30] <= 0;
            video_memory[31] <= 0;
        end
        else if (vid_write && clk_ctr > 15 && clk_ctr < 32) begin
            if (clk_ctr[3:0] < sprite_height && !Chip8CLK) begin
                video_memory[y_coords + clk_ctr[3:0]][x_coords +: 8] <= read_buffer[clk_ctr[3:0]] ^ video_memory[y_coords + clk_ctr[3:0]][x_coords +: 8];
            end
        end
    end


    always @(posedge Chip8CLK) begin
        start_loading <= (BTNR || BTNL || BTNC || BTNU || BTND);
        old_loading <= start_loading;
        if (start_loading && !old_loading) begin
            if (BTNL)
                which_rom <= 1;
            else if (BTNR)
                which_rom <= 0;
            else if (BTNU)
                which_rom <= 2;
            else if (BTND)
                which_rom <= 3;
            else if (BTNC)
                which_rom <= 4;
            else
                which_rom <= which_rom;

            i_reg <= 0;
            loading <= 1;
            program_counter <= 12'h200;
            write_enable <= 1;
            rom_index <= 0;
            vid_clear <= 1;
            write_count <= 15;

            write_buffer[0] <= 0;
            write_buffer[1] <= 0;
            write_buffer[2] <= 0;
            write_buffer[3] <= 0;
            write_buffer[4] <= 0;
            write_buffer[5] <= 0;
            write_buffer[6] <= 0;
            write_buffer[7] <= 0;
            write_buffer[8] <= 0;
            write_buffer[9] <= 0;
            write_buffer[10] <= 0;
            write_buffer[11] <= 0;
            write_buffer[12] <= 0;
            write_buffer[13] <= 0;
            write_buffer[14] <= 0;
            write_buffer[15] <= 0;

            registers[0] <= 0;
            registers[1] <= 0;
            registers[2] <= 0;
            registers[3] <= 0;
            registers[4] <= 0;
            registers[5] <= 0;
            registers[6] <= 0;
            registers[7] <= 0;
            registers[8] <= 0;
            registers[9] <= 0;
            registers[10] <= 0;
            registers[11] <= 0;
            registers[12] <= 0;
            registers[13] <= 0;
            registers[14] <= 0;
            registers[15] <= 0;
        end

        if (loading && !start_loading) begin
            write_buffer[0] <= rom_data;
            rom_index <= rom_index + 1;
            i_reg <= rom_index;
            if (rom_index == 12'hFFF) begin
                loading <= 0;
                write_enable <= 0;
                ERR <= 0;
                start_loading <= 0;
                vid_clear <= 0;
            end
        end
        else if (!loading && !start_loading) begin
            write_enable = 0;
            if (audio_set)
                audio_set <= 0;

            if (delay_set)
                delay_set <= 0;

            if (vid_write)
                vid_write <= 0;

            if (vid_clear)
                vid_clear <= 0;

            case (op_leader)
                0 : begin
                    if (current_opcode == 16'h00E0) begin
                        vid_clear <= 1;
                        program_counter <= program_counter + 2;
                    end
                    else if (current_opcode == 16'h00EE) begin
                        program_counter <= call_stack[stack_pointer - 1];
                        stack_pointer <= stack_pointer - 1;
                    end
                    else
                        ERR <= 1;
                end
                1: begin
                    program_counter <= op_address;
                end
                2: begin
                    call_stack[stack_pointer] <= program_counter + 2;
                    stack_pointer <= stack_pointer + 1;
                    program_counter <= op_address;
                end
                3: begin
                    if (registers[rx_sel] == op_const)
                        program_counter <= program_counter + 4;
                    else
                        program_counter <= program_counter + 2;
                end
                4: begin
                    if (registers[rx_sel] != op_const)
                        program_counter <= program_counter + 4;
                    else
                        program_counter <= program_counter + 2;
                end
                5: begin
                    if (cmp_out)
                        program_counter <= program_counter + 4;
                    else
                        program_counter <= program_counter + 2;
                end
                6: begin
                    registers[rx_sel] <= op_const;
                    program_counter <= program_counter + 2;
                end
                7: begin
                    registers[rx_sel] <= registers[rx_sel] + op_const;
                    program_counter <= program_counter + 2;
                end
                8: begin
                    case(op_nibble)
                        0: begin
                            registers[rx_sel] <= registers[ry_sel];
                        end
                        1: begin
                            registers[rx_sel] <= registers[rx_sel] | registers[ry_sel];
                        end
                        2: begin
                            registers[rx_sel] <= registers[rx_sel] & registers[ry_sel];
                        end
                        3: begin
                            registers[rx_sel] <= registers[rx_sel] ^ registers[ry_sel];
                        end
                        4: begin
                            alu_result = registers[rx_sel] + registers[ry_sel];
                            registers[rx_sel] <= alu_result[7:0];
                            registers[15] <= { 7'h00, alu_result[8] };
                        end
                        // 0x100 to set borrow correctly
                        5: begin
                            alu_result = registers[rx_sel] - registers[ry_sel];
                            registers[rx_sel] <= alu_result[7:0];
                            registers[15] <= { 7'h00, !alu_result[8] };
                        end
                        6: begin
                            registers[rx_sel] <= registers [ry_sel] >> 1;
                            registers[ry_sel] <= registers [ry_sel] >> 1;
                            registers[15] <= { 7'h00, registers[ry_sel][0] };
                        end
                        // 0x100 to set borrow correctly
                        7: begin
                            alu_result = registers[ry_sel] - registers[rx_sel];
                            registers[rx_sel] <= alu_result[7:0];
                            registers[15] <= { 7'h00, !alu_result[8] };
                        end
                        14: begin
                            registers[rx_sel] <= registers [ry_sel] << 1;
                            registers[ry_sel] <= registers [ry_sel] << 1;
                            registers[15] <= { 7'h00, registers[ry_sel][7] };
                        end
                        default: begin
                            ERR <= 1;
                        end
                    endcase
                    program_counter <= program_counter + 2;
                end
                9: begin
                    if (registers[rx_sel] != registers[ry_sel])
                        program_counter <= program_counter + 4;
                    else
                        program_counter <= program_counter + 2;
                end
                10: begin
                    i_reg <= op_address;
                    program_counter <= program_counter + 2;
                end
                11: begin
                    program_counter <= registers[0] + op_const;
                end
                12: begin
                    registers[rx_sel] <= random_number & op_const;
                    program_counter <= program_counter + 2;
                end
                13: begin
                    vid_write <= 1;
                    registers[15] <= 0;
                    x_coords <= registers[rx_sel];
                    y_coords <= registers[ry_sel];
                    sprite_height <= op_nibble;
                    //registers[15] = 0;
                    //display_ptr = video_index;
                    //for (repeat_ctr = 0; repeat_ctr < op_nibble; repeat_ctr = repeat_ctr + 1) begin
                    //    video_memory[display_ptr +: 8] = read_buffer[repeat_ctr];
                    //    if ((video_memory[video_index +: 8] & read_buffer[repeat_ctr]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //video_memory[display_ptr +: 8] = read_buffer[repeat_ctr];
                    //if ((video_memory[video_index +: 8] & read_buffer[repeat_ctr]) > 0)
                    //    registers[15] <= 1;
                    //if (op_nibble >= 0) begin
                    //    video_memory[video_index +: 8] <= read_buffer[0];
                    //    if ((video_memory[video_index +: 8] & read_buffer[0]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 1) begin
                    //    video_memory[video_index + screen_width * 1 +: 8] <= read_buffer[1];
                    //    if ((video_memory[video_index + screen_width * 1 +: 8] & read_buffer[1]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 2) begin
                    //    video_memory[video_index + screen_width * 2 +: 8] <= read_buffer[2];
                    //    if ((video_memory[video_index + screen_width * 2 +: 8] & read_buffer[2]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 3) begin
                    //    video_memory[video_index + screen_width * 3 +: 8] <= read_buffer[3];
                    //    if ((video_memory[video_index + screen_width * 3 +: 8] & read_buffer[3]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 4) begin
                    //    video_memory[video_index + screen_width * 4 +: 8] <= read_buffer[4];
                    //    if ((video_memory[video_index + screen_width * 4 +: 8] & read_buffer[4]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 5) begin
                    //    video_memory[video_index + screen_width * 5 +: 8] <= read_buffer[5];
                    //    if ((video_memory[video_index + screen_width * 5 +: 8] & read_buffer[5]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 6) begin
                    //    video_memory[video_index + screen_width * 6 +: 8] <= read_buffer[6];
                    //    if ((video_memory[video_index + screen_width * 6 +: 8] & read_buffer[6]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 7) begin
                    //    video_memory[video_index + screen_width * 7 +: 8] <= read_buffer[7];
                    //    if ((video_memory[video_index + screen_width * 7 +: 8] & read_buffer[7]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 8) begin
                    //    video_memory[video_index + screen_width * 8 +: 8] <= read_buffer[8];
                    //    if ((video_memory[video_index + screen_width * 8 +: 8] & read_buffer[8]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 9) begin
                    //    video_memory[video_index + screen_width * 9 +: 8] <= read_buffer[9];
                    //    if ((video_memory[video_index + screen_width * 9 +: 8] & read_buffer[9]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 10) begin
                    //    video_memory[video_index + screen_width * 10 +: 8] <= read_buffer[10];
                    //    if ((video_memory[video_index + screen_width * 10 +: 8] & read_buffer[10]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 11) begin
                    //    video_memory[video_index + screen_width * 11 +: 8] <= read_buffer[11];
                    //    if ((video_memory[video_index + screen_width * 11 +: 8] & read_buffer[11]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 12) begin
                    //    video_memory[video_index + screen_width * 12 +: 8] <= read_buffer[12];
                    //    if ((video_memory[video_index + screen_width * 12 +: 8] & read_buffer[12]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 13) begin
                    //    video_memory[video_index + screen_width * 13 +: 8] <= read_buffer[13];
                    //    if ((video_memory[video_index + screen_width * 13 +: 8] & read_buffer[13]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 14) begin
                    //    video_memory[video_index + screen_width * 14 +: 8] <= read_buffer[14];
                    //    if ((video_memory[video_index + screen_width * 14 +: 8] & read_buffer[14]) > 0)
                    //        registers[15] <= 1;
                    //end
                    //if (op_nibble >= 15) begin
                    //    video_memory[video_index + screen_width * 15 +: 8] <= read_buffer[15];
                    //    if ((video_memory[video_index + screen_width * 15 +: 8] & read_buffer[15]) > 0)
                    //        registers[15] <= 1;
                    //end
                    program_counter <= program_counter + 2;
                end
                14: begin
                    if (op_const == 8'h9E) begin
                        if (key_code == registers[rx_sel])
                            program_counter <= program_counter + 4;
                        else
                            program_counter <= program_counter + 2;
                    end
                    else if (op_const == 8'hA1) begin
                        if (key_code != registers[rx_sel])
                            program_counter <= program_counter + 4;
                        else
                            program_counter <= program_counter + 2;
                    end else
                        ERR <= 1;
                end
                15: begin
                    case (op_const)
                        8'h07: begin
                            registers[rx_sel] <= delay_value;
                            program_counter <= program_counter + 2;
                        end
                        8'h0A: begin
                            if (key_pressed) begin
                                registers[rx_sel] <= key_code;
                                program_counter <= program_counter + 2;
                            end else
                                program_counter <= program_counter; // halting operation. waits for key press
                        end
                        8'h15: begin
                            delay_in <= registers[rx_sel];
                            delay_set <= 1;
                            program_counter <= program_counter + 2;
                        end
                        8'h18: begin
                            audio_in <= registers[rx_sel];
                            audio_set <= 1;
                            program_counter <= program_counter + 2;
                        end
                        8'h1E: begin
                            i_reg <= i_reg + registers[rx_sel];
                            program_counter <= program_counter + 2;
                        end
                        8'h29: begin
                            i_reg <= registers[rx_sel] * 5;
                            program_counter <= program_counter + 2;
                        end
                        8'h33: begin
                            write_enable = 1;
                            write_count <= 2;
                            // tomfoolery because of write delay
                            write_buffer[2] <= registers[rx_sel] / 100;
                            write_buffer[0] <= (registers[rx_sel] % 100) / 10;
                            write_buffer[1] <= registers[rx_sel] % 10;
                            program_counter <= program_counter + 2;
                        end
                        8'h55: begin
                            write_enable = 1;
                            write_count <= rx_sel;
                            i_reg <= i_reg + rx_sel + 1;
                            // tomfoolery because of write delay
                            if (rx_sel >= 0) write_buffer[rx_sel] <= registers[0];
                            if (rx_sel >= 1) write_buffer[0] <= registers[1];
                            if (rx_sel >= 2) write_buffer[1] <= registers[2];
                            if (rx_sel >= 3) write_buffer[2] <= registers[3];
                            if (rx_sel >= 4) write_buffer[3] <= registers[4];
                            if (rx_sel >= 5) write_buffer[4] <= registers[5];
                            if (rx_sel >= 6) write_buffer[5] <= registers[6];
                            if (rx_sel >= 7) write_buffer[6] <= registers[7];
                            if (rx_sel >= 8) write_buffer[7] <= registers[8];
                            if (rx_sel >= 9) write_buffer[8] <= registers[9];
                            if (rx_sel >= 10) write_buffer[9] <= registers[10];
                            if (rx_sel >= 11) write_buffer[10] <= registers[11];
                            if (rx_sel >= 12) write_buffer[11] <= registers[12];
                            if (rx_sel >= 13) write_buffer[12] <= registers[13];
                            if (rx_sel >= 14) write_buffer[13] <= registers[14];
                            if (rx_sel >= 15) write_buffer[14] <= registers[15];
                            program_counter <= program_counter + 2;
                        end
                        8'h65: begin
                            if (rx_sel >= 0) registers[0] <= read_buffer[0];
                            if (rx_sel >= 1) registers[1] <= read_buffer[1];
                            if (rx_sel >= 2) registers[2] <= read_buffer[2];
                            if (rx_sel >= 3) registers[3] <= read_buffer[3];
                            if (rx_sel >= 4) registers[4] <= read_buffer[4];
                            if (rx_sel >= 5) registers[5] <= read_buffer[5];
                            if (rx_sel >= 6) registers[6] <= read_buffer[6];
                            if (rx_sel >= 7) registers[7] <= read_buffer[7];
                            if (rx_sel >= 8) registers[8] <= read_buffer[8];
                            if (rx_sel >= 9) registers[9] <= read_buffer[9];
                            if (rx_sel >= 10) registers[10] <= read_buffer[10];
                            if (rx_sel >= 11) registers[11] <= read_buffer[11];
                            if (rx_sel >= 12) registers[12] <= read_buffer[12];
                            if (rx_sel >= 13) registers[13] <= read_buffer[13];
                            if (rx_sel >= 14) registers[14] <= read_buffer[14];
                            if (rx_sel >= 15) registers[15] <= read_buffer[15];
                            program_counter <= program_counter + 2;
                            i_reg <= i_reg + rx_sel + 1;
                        end
                        default: ERR <= 1;
                    endcase
                end
            endcase
        end
    end
endmodule
