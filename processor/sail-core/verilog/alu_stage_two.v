/*
 *	Description:
 *
 *		Stage 2 of ALU to calculate addition / subtraction of first 16 bits.
 */

module alu_stage_two(A, B, ALUOut_1, Branch_Enable_1,
                     addition_flag ,last_16_bits_result,carry_bit,
                     ALUOut, Branch_Enable);
	input [31:0]		A;
	input [31:0]		B;
    input [31:0]        ALUOut_1;
	input               Branch_Enable_1;
    input               addition_flag;
    input               carry_bit;
    input [15:0]        last_16_bits_result;

    output [31:0]		ALUOut;
    output				Branch_Enable;

    reg [31:0]          first_16_bits_result;

	initial begin
        first_16_bits_result = 16'b0;
	end

    always @(A, B, ALUOut_1,Branch_Enable_1, addition_flag, last_16_bits_result) begin
        case(addition_flag) 
            1'b0: begin
                ALUOut = ALUOut_1;
                Branch_Enable = Branch_Enable_1;
            end
            1'b1: begin // addition
                first_16_bits_result = A[31:16] + B[31:16] + carry_bit;
                ALUOut = {first_16_bits_result, last_16_bits_result};
                Branch_Enable = Branch_Enable_1;
            end
        endcase
    end 
endmodule