module subtractor(input1, input2, out);
    input [31:0] input1;
    input [31:0] input2;
    output reg [31:0] out;

    wire [15:0] lower_part, upper_part_no_carry, upper_part_with_carry;
    wire carry_from_lower;

    // Calculate the lower 16 bits
    adder16 adder_bot (
        .input1(~input1[15:0]), // negate the lower 16 bits of input1
        .input2(input2[15:0]),
        .carry_in(1'b0),
        .out(lower_part),
        .carry_out(carry_from_lower)
    );

    // Calculate the upper 16 bits without carry from the lower 16 bits
    adder16 adder_top_no_carry (
        .input1(~input1[31:16]), // negate the upper 16 bits of input1
        .input2(input2[31:16]),
        .carry_in(1'b0),
        .out(upper_part_no_carry),
        .carry_out()
    );

    // Calculate the upper 16 bits with carry from the lower 16 bits
    adder16 adder_top_with_carry (
        .input1(~input1[31:16]), // negate the upper 16 bits of input1
        .input2(input2[31:16]),
        .carry_in(1'b1),
        .out(upper_part_with_carry),
        .carry_out()
    );

    // Decide the output based on the carry from the lower 16 bits
	always @(lower_part or carry_from_lower or upper_part_no_carry or upper_part_with_carry) begin
		out[15:0] = ~lower_part;
		out[31:16] = carry_from_lower ? ~upper_part_with_carry : ~upper_part_no_carry;
	end

endmodule
