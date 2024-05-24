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
 *	Description:
 *
 *		This module implements an DSP based 32 bits subtractor for use in ALU.
 */


module dsp_subtractor(
    input [31:0] input1,          // 32-bit input 1
    input [31:0] input2,          // 32-bit input 2
    output wire [31:0] out         // 32-bit output
);

	// Internal connections for DSP block
	wire [15:0] A, B, C, D;
	wire [31:0] O;

	// Assign inputs to 16-bit segments for DSP processing
	assign A = input1[15:0];
	assign B = input1[31:16];
	assign C = input2[15:0];
	assign D = input2[31:16];

	SB_MAC16 i_sbmac16
		( // port interfaces
		.A(A),
		.B(B),
		.C(C),
		.D(D),
		.O(O), //32-bit output
		.CLK(1'b0), // connect clk to zero
		.CE(1'b1), // default to enable
		.IRSTTOP(1'b0),
		.IRSTBOT(1'b0),
		.ORSTTOP(1'b0),
		.ORSTBOT(1'b0),
		.AHOLD(1'b0),
		.BHOLD(1'b0),
		.CHOLD(1'b0),
		.DHOLD(1'b0),
		.OHOLDTOP(1'b0),
		.OHOLDBOT(1'b0),
		.OLOADTOP(1'b0),
		.OLOADBOT(1'b0),
		.ADDSUBTOP(1'b1), // subtract
		.ADDSUBBOT(1'b1), // subtract
		.CO(), // check, do we need to connect this carry bit out?
		.CI(1'b0), // no carry in
		.ACCUMCI(),
		.ACCUMCO(),
		.SIGNEXTIN(),
		.SIGNEXTOUT()
		);
	defparam i_sbmac16.NEG_TRIGGER = 1'b0;
	// No need for registers
	defparam i_sbmac16.A_REG = 1'b0;
	defparam i_sbmac16.B_REG = 1'b0;
	defparam i_sbmac16.C_REG = 1'b0;
	defparam i_sbmac16.D_REG = 1'b0;

	defparam i_sbmac16.TOP_8x8_MULT_REG = 1'b0;
	defparam i_sbmac16.BOT_8x8_MULT_REG = 1'b0;
	defparam i_sbmac16.PIPELINE_16x16_MULT_REG1 = 1'b0;
	defparam i_sbmac16.PIPELINE_16x16_MULT_REG2 = 1'b0;

	defparam i_sbmac16.TOPOUTPUT_SELECT = 2'b00; //subtractor, not registered
	defparam i_sbmac16.TOPADDSUB_LOWERINPUT = 2'b00;
	defparam i_sbmac16.TOPADDSUB_UPPERINPUT = 1'b0;
	defparam i_sbmac16.TOPADDSUB_CARRYSELECT = 2'b11; // carry bit from the lower subtractor

	defparam i_sbmac16.BOTOUTPUT_SELECT = 2'b00;
	defparam i_sbmac16.BOTADDSUB_LOWERINPUT = 2'b00;
	defparam i_sbmac16.BOTADDSUB_UPPERINPUT = 1'b0;
	defparam i_sbmac16.BOTADDSUB_CARRYSELECT = 2'b00; // no need for carry bit
	defparam i_sbmac16.MODE_8x8 = 1'b0;
	
	defparam i_sbmac16.A_SIGNED = 1'b0;
	defparam i_sbmac16.B_SIGNED = 1'b0;

	// Since operation is not clock dependent, output can be assigned directly
	assign out = O;

endmodule
