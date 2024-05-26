`define	kFofE_HFOSC_CLOCK_DIVIDER_FOR_1Hz	12000000

module blink(led);
	output		led;

	wire		clk;
	reg		LEDstatus = 1;
	reg [31:0]	count = 0;

    wire [31:0] adder_out;
    wire [31:0] adder_input1;
    wire [31:0] adder_input2;

    assign adder_input1 = 32'h00000000;
    assign adder_input2 = 32'h11111111;

    dsp_add_sub adder_inst (
        .input1(adder_input1),
        .input2(adder_input2),
		.add_sub(1'b0),
        .out(adder_out)
    );

	/*
	 *	Creates a 48MHz clock signal from
	 *	internal oscillator of the iCE40
	 */
	SB_HFOSC OSCInst0 (
		.CLKHFPU(1'b1),
		.CLKHFEN(1'b1),
		.CLKHF(clk)
	);
	defparam OSCInst0.CLKHF_DIV = "0b01";

	/*
	 * If the adder_out is not zero, then blink the LED
	 * otherwise (when the result is correct), keep the LED on
	 */
	always @(posedge clk) begin
		if (adder_out != 32'h11111111) begin
			if (count > `kFofE_HFOSC_CLOCK_DIVIDER_FOR_1Hz) begin
				LEDstatus <= !LEDstatus;
				count <= 0;
			end else begin
				count <= count + 1;
			end
		end else begin
			LEDstatus <= 1;
		end
	end

	/*
	 *	Assign output led to value in LEDstatus register
	 */
	assign	led = LEDstatus;
endmodule
