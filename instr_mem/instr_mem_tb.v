// Testbench for the RISC-V Instruction Memory Module
module instruction_memory_tb;

    // Testbench signals
    reg clk;
    reg [31:0] addr;
    wire [31:0] out;
    wire clk_stall;

    // Instantiate the instruction memory module
    instruction_memory uut (
        .clk(clk),
        .addr(addr),
        .out(out),
        .clk_stall(clk_stall)
    );

    // Clock generator
    initial begin
        clk = 0;
        // Clock with a period of 10 time units
        forever #5 clk = ~clk;
    end

    // Initial block to simulate test scenarios
    initial begin
        // Initialize address
        addr = 32'h0;
        #100;  // Wait 100 time units for global reset, stabilization

        // First address fetch test
        addr = 32'h4;  // Set address to 4
        #20;           // Wait for memory response
        addr = 32'h8;  // Change to next address
        #20;           // Wait for response
        addr = 32'hC;  // Next sequential address
        #20;           // Observe outputs
        
        // Random access test
        addr = 32'h100; // Jump to an arbitrary address
        #20;
        addr = 32'h104;
        #20;

        // End simulation
        $finish;
    end

    // Monitor block to output the results
    initial begin
        $monitor("Time=%g, Addr=%h, Out=%h, ClkStall=%b", $time, addr, out, clk_stall);
    end

endmodule
