`include "../include/rv32i-defines.v"
`include "../include/sail-core-defines.v"



/*
 *	Description:
 *
 *		Stage 1 of ALU to calculate addition / subtraction of last 16 bits.
 */



/*
 *	Not all instructions are fed to the ALU. As a result, the ALUctl
 *	field is only unique across the instructions that are actually
 *	fed to the ALU.
 */
module alu_stage_one(ALUctl, A, B, ALUOut, Branch_Enable, addition_flag, carry_bit, last_16_bits_result);
	input [6:0]		ALUctl;
	input [31:0]		A;
	input [31:0]		B;
	output reg [31:0]	ALUOut;
	output reg		Branch_Enable;

    // Additional outputs for segmenting addition and subtraction //
	output reg		addition_flag; // Changed to registor
    output reg		carry_bit; // Should also be a reg since it's driven by procedural code
	output reg [15:0]		last_16_bits_result;
    ////////////////////////////////////////////////////////////////

	/*
	 *	This uses Yosys's support for nonzero initial values:
	 *
	 *		https://github.com/YosysHQ/yosys/commit/0793f1b196df536975a044a4ce53025c81d00c7f
	 *
	 *	Rather than using this simulation construct (`initial`),
	 *	the design should instead use a reset signal going to
	 *	modules in the design.
	 */
	initial begin
		ALUOut = 32'b0;
		Branch_Enable = 1'b0;
		carry_bit = 1'b0; // Initialize carry bit to 0
		last_16_bits_result = 16'b0; // Initialize last 16 bits result to 0
	end

	always @(ALUctl, A, B) begin
		case (ALUctl[3:0])
			/*
			 *	AND (the fields also match ANDI and LUI)
			 */
			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_AND: begin
				addition_flag = 1'b0;
				ALUOut = A & B;
			end

			/*
			 *	OR (the fields also match ORI)
			 */
			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_OR: begin
				addition_flag = 1'b0;
				ALUOut = A | B;
			end

			/*
			 *	ADD (last 16 bits)
			 */
			
			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_ADD: begin
				addition_flag = 1'b1; //assign addition flag to 1
				{carry_bit, last_16_bits_result} = {1'b0, A[15:0]} + {1'b0, B[15:0]};
				ALUOut = 32'b0;
			end

			/*
			 *	SUBTRACT (the fields also matches all branches)
			 */
			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_SUB: begin
				addition_flag = 1'b0;
				ALUOut = A - B;
			end

			/*
			 *	SLT (the fields also matches all the other SLT variants)
			 */
			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_SLT: begin
				addition_flag = 1'b0;
				ALUOut = $signed(A) < $signed(B) ? 32'b1 : 32'b0;
			end

			/*
			 *	SRL (the fields also matches the other SRL variants)
			 */
			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_SRL: begin
				addition_flag = 1'b0;
				ALUOut = A >> B[4:0];
			end

			/*
			 *	SRA (the fields also matches the other SRA variants)
			 */
			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_SRA: begin
				addition_flag = 1'b0;
				ALUOut = $signed(A) >>> B[4:0];
			end

			/*
			 *	SLL (the fields also match the other SLL variants)
			 */
			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_SLL: begin
				addition_flag = 1'b0;
				ALUOut = A << B[4:0];
			end

			/*
			 *	XOR (the fields also match other XOR variants)
			 */

			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_XOR: begin
				addition_flag = 1'b0;
				ALUOut = A ^ B;
			end

			/*
			 *	CSRRW  only
			 */
			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_CSRRW: begin
				addition_flag = 1'b0;
				ALUOut = A;
			end

			/*
			 *	CSRRS only
			 */
			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_CSRRS:	begin
				addition_flag = 1'b0;
				ALUOut = A | B;
			end

			/*
			 *	CSRRC only
			 */
			`kSAIL_MICROARCHITECTURE_ALUCTL_3to0_CSRRC:	begin
				addition_flag = 1'b0;
				ALUOut = (~A) & B;
			end

			/*
			 *	Should never happen.
			 */
			default: begin
				addition_flag = 1'b0;
				ALUOut = 0;
			end
		endcase
	end

	always @(ALUctl, ALUOut, A, B) begin
		case (ALUctl[6:4])
			`kSAIL_MICROARCHITECTURE_ALUCTL_6to4_BEQ:	Branch_Enable = (ALUOut == 0);
			`kSAIL_MICROARCHITECTURE_ALUCTL_6to4_BNE:	Branch_Enable = !(ALUOut == 0);
			`kSAIL_MICROARCHITECTURE_ALUCTL_6to4_BLT:	Branch_Enable = ($signed(A) < $signed(B));
			`kSAIL_MICROARCHITECTURE_ALUCTL_6to4_BGE:	Branch_Enable = ($signed(A) >= $signed(B));
			`kSAIL_MICROARCHITECTURE_ALUCTL_6to4_BLTU:	Branch_Enable = ($unsigned(A) < $unsigned(B));
			`kSAIL_MICROARCHITECTURE_ALUCTL_6to4_BGEU:	Branch_Enable = ($unsigned(A) >= $unsigned(B));

			default:					Branch_Enable = 1'b0;
		endcase
	end
endmodule
