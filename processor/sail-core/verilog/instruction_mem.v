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
 *	RISC-V instruction memory
 */

module instruction_memory (
    input wire clk,
    input wire [31:0] addr,
    output reg [31:0] out,
    output reg clk_stall
);

    // Define the states of the FSM
    localparam IDLE = 0, FETCH = 1;

    // Instruction memory array
    reg [31:0] instruction_memory[0:2**10-1]; // Assuming 4K words of memory

    // FSM state variable
    reg state = IDLE;

    // Internal address register to hold the previous address
    reg [31:0] previous_addr;
    reg [31:0] addr_buf;

    // Memory initialization (using Yosys's support for nonzero initial values)
    initial begin
        $readmemh("verilog/program.hex", instruction_memory);
        previous_addr = 32'hFFFFFFFF; // Initialize previous address
        clk_stall = 0; // Initialize clk_stall to 0
    end

    // FSM to manage instruction fetching based on address change
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                clk_stall <= 0;
                addr_buf <= addr; // Store the current address
                if (addr != previous_addr) begin
                    previous_addr <= addr; // Update the previous address
                    state <= FETCH; // Move to fetch state if address changes
					clk_stall <= 1; // Stall the CPU while fetching the instruction
                end
            end

            FETCH: begin
				clk_stall <= 0;
                out <= instruction_memory[addr_buf >> 2]; // Perform the memory read
                state <= IDLE; // Go back to idle state
            end
        endcase
    end

endmodule
