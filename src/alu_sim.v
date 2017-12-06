module ALU_sim ();

    reg clk = 0;
    reg [7:0] op1 = 0;
    reg [7:0] op2 = 0;
    reg [3:0] opcode = 4'h4;
    wire [7:0] out;
    wire carry;
    wire ALU_ERR;

    ALU alu (
        .clk(clk),
        .op1(op1),
        .op2(op2),
        .opcode(opcode),
        .out(out),
        .carry(carry),
        .ALU_ERR(ALU_ERR));

    always begin
        #1 clk <= ~clk;
    end

    initial begin

        #4  op1 <= 8'hFF;
        #4  op2 <= 8'h01;
        #4  opcode <= 4'h5;
        #4  opcode <= 4'h7;
        #4  opcode <= 4'h6;
        #4  opcode <= 4'hE;
        #4  opcode <= 4'h0;
        #4  opcode <= 4'h1;
        #4  opcode <= 4'h2;
        #4  opcode <= 4'h3;
        #4;

        $finish;
    end

endmodule
