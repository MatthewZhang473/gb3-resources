
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
				// clk_stall <= 0;
                out <= instruction_memory[addr_buf >> 2]; // Perform the memory read
                state <= IDLE; // Go back to idle state
                clk_stall <= 0; 
            end
        endcase
    end

endmodule
