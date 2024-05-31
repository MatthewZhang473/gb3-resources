// Testbench for the 16-bit adder module
`timescale 1ns / 1ps

module adder16_testbench;

    // Inputs
    reg [15:0] input1;
    reg [15:0] input2;
    reg carry_in;

    // Outputs
    wire [15:0] out;
    wire carry_out;

    // Instantiate the Unit Under Test (UUT)
    adder16 uut (
        .input1(input1), 
        .input2(input2), 
        .carry_in(carry_in), 
        .carry_out(carry_out),
        .out(out)
    );

    // Test Stimulus
    initial begin
        // Initialize Inputs
        input1 = 0; input2 = 0; carry_in = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        input1 = 16'h1; input2 = 16'h1; carry_in = 0;
        #10;  // Apply inputs for 10 ns
        input1 = 16'hFFFF; input2 = 16'h0001; carry_in = 1;
        #10;
        input1 = 16'h1234; input2 = 16'hFEDC; carry_in = 0;
        #10;
        input1 = 16'h8000; input2 = 16'h7FFF; carry_in = 1;
        #10;
        input1 = 16'h0000; input2 = 16'h0000; carry_in = 1;
        #10;
        
        $finish;  // End simulation
    end

    // Monitor changes and print them
    initial begin
        $monitor("Time = %t, input1 = %h, input2 = %h, carry_in = %b, out = %h, carry_out = %b",
                 $time, input1, input2, carry_in, out, carry_out);
    end

endmodule
