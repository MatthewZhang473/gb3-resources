`timescale 1ns / 1ps

module subtractor_testbench;

    reg [31:0] input1;
    reg [31:0] input2;
    wire [31:0] out;

    // Instantiate the subtractor module
    subtractor uut (
        .input1(input1),
        .input2(input2),
        .out(out)
    );

    initial begin
        // Initialize inputs
        input1 = 0;
        input2 = 0;

        // Test 1: Simple subtraction
        #10 input1 = 32'h0000_0002; input2 = 32'h0000_0001;  // Expected result: 1
        #10 input1 = 32'h0000_FFFF; input2 = 32'h0000_0001;  // Expected result: FFFE
        #10 input1 = 32'h8000_0000; input2 = 32'h0000_0001;  // Large number subtraction
        #10 input1 = 32'h7FFF_FFFF; input2 = 32'h0000_0001;  // Large number subtraction
        #10 input1 = 32'hFFFFFFFF; input2 = 32'h00000001;    // Edge case for wrap-around
        #10 input1 = 32'h12345678; input2 = 32'h87654321;    // Random complex subtraction
        #10 input1 = 32'h1000_0000; input2 = 32'h0000_0001;  // lots of carries

        #10 $finish; // End the simulation
    end

    // Monitor and display results
    initial begin
        $monitor("At time %t, input1 = %h, input2 = %h, out = %h",
                 $time, input1, input2, out);
    end

endmodule
