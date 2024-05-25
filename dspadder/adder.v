/*
 *	Description:
 *
 *		This module implements an adder for use by the branch unit
 *		and program counter increment among other things.
 */



module adder(input1, input2, out);
	input [31:0]	input1;
	input [31:0]	input2;
	output [31:0]	out;

	assign		out = input1 + input2;
endmodule