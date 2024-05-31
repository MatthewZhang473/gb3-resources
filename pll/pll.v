`define	kFofE_HFOSC_CLOCK_DIVIDER_FOR_1Hz	12000000

//input external 12MHz clk disabled, as we are using the PLL with internal oscillator, having both don't seem possible
module top(led);
    output led;
    wire clk_48mhz; //internal
    wire clk_16mhz;

	reg		    LEDstatus = 1;
	reg [31:0]	count = 0;

   //internal oscillators seen as modules
   SB_HFOSC SB_HFOSC_inst(
      .CLKHFEN(1'b1),
      .CLKHFPU(1'b1),
      .CLKHF(clk_48mhz)
   );

   SB_PLL40_CORE #(
      .FEEDBACK_PATH("SIMPLE"),
      .PLLOUT_SELECT("GENCLK"),
      .DIVR(4'b0010),
      .DIVF(7'b0111111),
      .DIVQ(3'b110),
      .FILTER_RANGE(3'b001),
    ) SB_PLL40_CORE_inst (
      .RESETB(1'b1),
      .BYPASS(1'b0),
      .PLLOUTCORE(clk_16mhz),
      .REFERENCECLK(clk_48mhz)
   );

	always @(posedge clk_16mhz) begin
		if (count > `kFofE_HFOSC_CLOCK_DIVIDER_FOR_1Hz) begin
			LEDstatus <= !LEDstatus;
			count <= 0;
		end
		else begin
			count <= count + 1;
		end
	end

	/*
	 *	Assign output led to value in LEDstatus register
	 */
	assign	led = LEDstatus;

endmodule