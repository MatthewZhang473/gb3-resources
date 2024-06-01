`timescale 1ns / 1ps

module adder_testbench;

    reg [31:0] input1;
    reg [31:0] input2;
    wire [31:0] out;

    // Instantiate the adder module
    adder uut (
        .input1(input1),
        .input2(input2),
        .out(out)
    );

    initial begin
        // Initialize inputs
        input1 = 0;
        input2 = 0;

        // Apply test vectors
        #10 input1 = 32'h0001_0001; input2 = 32'h0001_0001; // Test simple addition without carry
        #10 input1 = 32'hFFFF_0000; input2 = 32'h0001_0000; // Test addition with carry from lower to upper
        #10 input1 = 32'hFFFF_FFFF; input2 = 32'h0000_0001; // Test boundary condition
        #10 input1 = 32'h8000_0000; input2 = 32'h8000_0000; // Test large number addition
        #10 input1 = 32'h7FFF_FFFF; input2 = 32'h0000_0001; // Edge case for overflow
        #10 input1 = 32'h1234_5678; input2 = 32'h8765_4321; // Random addition

        #10 $finish; // End the simulation
    end

    // Optional: Monitor changes and display them
    initial begin
        $monitor("At time %t, input1 = %h, input2 = %h, out = %h",
                 $time, input1, input2, out);
    end

endmodule
