// Displays a 64x32 pixel memory onto a 640x480 VGA display

module Display (
    input SYS_CLK,
    input [0:2047] flat_video_memory,
    output reg VGA_HS,
    output reg VGA_VS,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B);

    reg VIDACT = 0;
    reg display = 0;

    assign VGA_R[3] = display;
    assign VGA_R[2] = display;
    assign VGA_R[1] = display;
    assign VGA_R[0] = display;
    assign VGA_G[3] = display;
    assign VGA_G[2] = display;
    assign VGA_G[1] = display;
    assign VGA_G[0] = display;
    assign VGA_B[3] = display;
    assign VGA_B[2] = display;
    assign VGA_B[1] = display;
    assign VGA_B[0] = display;

    parameter hsync_end   = 95,
              hdat_begin  = 143,
              hdat_end  = 783,
              hpixel_end  = 799,
              vsync_end  = 1,
              vdat_begin  = 110,
              vdat_end  = 430,
              vline_end  = 520;

    reg [9:0] hcount = 0;
    reg [9:0] vcount = 0;
    reg [1:0] count = 0;
    reg [9:0] v_vid_counter = 0;
    reg [9:0] h_vid_counter = 0;
    reg [4:0] v_index = 0;
    reg [5:0] h_index = 0;
    reg [10:0] vid_index;
    reg clk25MHz = 0;

    wire [0:63] video_memory [0:31];

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


    always @(posedge SYS_CLK) begin
        count<=count+1;
        clk25MHz<=count[1];
    end
    //counter for horizontal sync
    always @(posedge clk25MHz) begin
        if (hcount == hpixel_end) begin
            hcount <= 0;
            if (vcount == vline_end) begin
                vcount <= 0;
            end else begin
                vcount <= vcount + 1;
                if (vcount >= vdat_begin && vcount < vdat_end) begin
                    if (v_vid_counter < 9)
                        v_vid_counter <= v_vid_counter + 1;
                    else begin
                        v_vid_counter <= 0;
                        v_index <= v_index + 1;
                    end
                end else
                    v_index <= 0;
            end
        end else begin
            hcount <= hcount + 1;
            if (hcount >= hdat_begin && hcount < hdat_end) begin
                if (h_vid_counter < 9)
                    h_vid_counter <= h_vid_counter + 1;
                else begin
                    h_vid_counter <= 0;
                    h_index <= h_index + 1;
                end
            end else
                h_index <= 0;
        end

    end

    always @(posedge SYS_CLK) begin
        VGA_HS <= (hcount > hsync_end);
        VGA_VS <= (vcount > vsync_end);
        VIDACT<=((hcount >= hdat_begin) && (hcount < hdat_end))
                && ((vcount >= vdat_begin) && (vcount < vdat_end));

        if (VIDACT) begin
            display <= video_memory[v_index][h_index];
        end else begin
            display <= 0;
        end
    end

endmodule
