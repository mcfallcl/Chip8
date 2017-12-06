/*
 * Author: Christopher McFall
 * Project: CHIP8 Interpreter
 *
 * ALU for a hardware representation of the CHIP8 Interpreter.
 *
 * NOTE: shifts require both registers to change.
 * Opcodes:
 *      0b0000: assign          op1 <= op2
 *      0b0001: logical OR      op1 <= op1 | op2
 *      0b0010: logical AND     op1 <= op1 & op2
 *      0b0011: logical XOR     op1 <= op1 ^ op2
 *      0b0100: addition        op1 <= op1 + op2, carry to rF
 *      0b0101: subtraction     op1 <= op1 - op2, borrow to rF
 *      0b0110: shift right     op1, op2 <= op2 >> 1, lsb to rF
 *      0b0111: rev subtract    op1 <= op2 - op1, borrow to rF
 *      0b1110: shift left      op1, op2 <= op2 << 1, msb to rF
 */

module ALU (
	input clk,
	input [7:0] op1,
	input [7:0] op2,
	input [3:0] opcode,
    // should always go to op1 outside of module.
	output [7:0] out,
	// Carry is stored in a full 8-bit GP register.
	output carry,
    output reg ALU_ERR = 0);

    reg [8:0] result = 0;
    assign out = result[7:0];
    assign carry = result[8];

    always @(posedge clk) begin
        case(opcode)
            0: begin
                result <= op2;
                ALU_ERR <= 0;
            end
            1: begin
                result <= op1 | op2;
                ALU_ERR <= 0;
            end
            2: begin
                result <= op1 & op2;
                ALU_ERR <= 0;
            end
            3: begin
                result <= op1 ^ op2;
                ALU_ERR <= 0;
            end
            4: begin
                result <= op1 + op2;
                ALU_ERR <= 0;
            end
            // 0x100 to set borrow correctly
            5: begin
                result <= op1 - op2 + 9'h100;
                ALU_ERR <= 0;
            end
            6: begin
                result[8] <= op2[0];
                result[7:0] <= op2 >> 1;
                ALU_ERR <= 0;
            end
            // 0x100 to set borrow correctly
            7: begin
                result <= op2 - op1 + 9'h100;
                ALU_ERR <= 0;
            end
            14: begin
                result <= op2 << 1;
                ALU_ERR <= 0;
            end
            default: begin
                ALU_ERR <= 1;
                result[8] <= 1'bx;
                result[7:0] <= 8'bxxxxxxxx;
            end
        endcase
    end

endmodule
