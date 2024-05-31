
module adder16(input1, input2, carry_in, out,carry_out);
	input [15:0]	input1;
	input [15:0]	input2;
    input  carry_in;
	output [15:0]	out;
    output carry_out;

	assign	{carry_out, out} = {1'b0, input1} + {1'b0, input2} + carry_in;

endmodule
