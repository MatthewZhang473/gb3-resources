/*
	Authored 2018-2019, Ryan Voo.

	All rights reserved.
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions
	are met:

	*	Redistributions of source code must retain the above
		copyright notice, this list of conditions and the following
		disclaimer.

	*	Redistributions in binary form must reproduce the above
		copyright notice, this list of conditions and the following
		disclaimer in the documentation and/or other materials
		provided with the distribution.

	*	Neither the name of the author nor the names of its
		contributors may be used to endorse or promote products
		derived from this software without specific prior written
		permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
	COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
	ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/



/*
 *		Branch Predictor FSM
 */

module branch_predictor(
		clk,
		actual_branch_decision,
		branch_decode_sig,
		branch_mem_sig,
		in_addr,
		offset,
		branch_addr,
		prediction
	);

	/*
	 *	inputs
	 */
	input		clk;
	input		actual_branch_decision;
	input		branch_decode_sig;
	input		branch_mem_sig;
	input [31:0]	in_addr;
	input [31:0]	offset;

	/*
	 *	outputs
	 */
	output [31:0]	branch_addr;
	output		prediction;

	/*
	 *	internal state
	 */
	reg [1:0]	s;

	reg		branch_mem_sig_reg;


	// DSP adder to replace addition for branch_addr
	wire [31:0]     dsp_addr_adder_result;
	dsp_adder addr_adder_unit(
        .input1(in_addr),
        .input2(offset),
        .out(dsp_addr_adder_result)
    );

	/*
	 *	The `initial` statement below uses Yosys's support for nonzero
	 *	initial values:
	 *
	 *		https://github.com/YosysHQ/yosys/commit/0793f1b196df536975a044a4ce53025c81d00c7f
	 *
	 *	Rather than using this simulation construct (`initial`),
	 *	the design should instead use a reset signal going to
	 *	modules in the design and to thereby set the values.
	 */
	initial begin
		s = 2'b00;
		branch_mem_sig_reg = 1'b0;
	end

	always @(negedge clk) begin
		branch_mem_sig_reg <= branch_mem_sig;
	end

	/*
	 *	Using this microarchitecture, branches can't occur consecutively
	 *	therefore can use branch_mem_sig as every branch is followed by
	 *	a bubble, so a 0 to 1 transition
	 */
	always @(posedge clk) begin
		if (branch_mem_sig_reg) begin
			s[1] <= (s[1]&s[0]) | (s[0]&actual_branch_decision) | (s[1]&actual_branch_decision);
			s[0] <= (s[1]&(!s[0])) | ((!s[0])&actual_branch_decision) | (s[1]&actual_branch_decision);
		end
	end

	// Replacing the addition operation with the DSP adder
	assign branch_addr = dsp_addr_adder_result;
	// assign branch_addr = in_addr + offset;
	assign prediction = s[1] & branch_decode_sig;
endmodule

// module hybrid_branch_predictor(
//     input clk,
//     input reset,
//     input [31:0] branch_addr,
//     input actual_branch_decision,
//     input branch_decode_sig,
//     output reg [31:0] prediction_table [0:1023],  // Prediction table for Gshare
//     output reg prediction
// );

//     // Parameters
//     parameter HISTORY_LENGTH = 8;  // Length of the Global History Register

//     // Registers
//     reg [HISTORY_LENGTH-1:0] global_history;  // Global History Register
//     reg [1:0] local_counters [0:1023];  // Local counters for branches
//     reg [31:0] gshare_index;  // Index for the Gshare prediction table

//     // Initial block to set up initial states
//     initial begin
//         global_history = 0;
//         for (int i = 0; i < 1024; i++) begin
//             local_counters[i] = 2'b01;  // Initialize to weakly not taken
//             prediction_table[i] = 0;  // Initialize Gshare table
//         end
//     end

//     // Update logic for global history and local counters
//     always @(posedge clk) begin
//         if (reset) begin
//             global_history <= 0;
//         end else if (branch_decode_sig) begin
//             // Update local predictor
//             case (local_counters[branch_addr[9:0]])
//                 2'b00: local_counters[branch_addr[9:0]] <= actual_branch_decision ? 2'b01 : 2'b00;
//                 2'b01: local_counters[branch_addr[9:0]] <= actual_branch_decision ? 2'b11 : 2'b00;
//                 2'b10: local_counters[branch_addr[9:0]] <= actual_branch_decision ? 2'b11 : 2'b01;
//                 2'b11: local_counters[branch_addr[9:0]] <= actual_branch_decision ? 2'b11 : 2'b10;
//             endcase

//             // Update global history
//             global_history <= (global_history << 1) | actual_branch_decision;

//             // Calculate index for Gshare
//             gshare_index = branch_addr[9:0] ^ (global_history & 1023);

//             // Update prediction table using Gshare index
//             prediction_table[gshare_index] <= actual_branch_decision;
//         end
//     end

//     // Predict based on the most confident source
//     always @* begin
//         if (branch_decode_sig) begin
//             prediction = local_counters[branch_addr[9:0]][1] & prediction_table[gshare_index];
//         end
//     end
// endmodule