module branch_predictor(
		clk,
        reset,
		actual_branch_decision,
		branch_decode_sig,
		branch_mem_sig,
		in_addr,
        offset,
		branch_addr,
		prediction
	);

	/*
	 *	inputs
	 */
    input        clk;
    input        reset;
    input        actual_branch_decision;
    input        branch_decode_sig;
    input        branch_mem_sig;
    input [31:0] in_addr;
    input [31:0] offset;

	/*
     *  outputs
	 */
    output wire [31:0] branch_addr;
    output reg        prediction;

	/*
     *  Gshare Predictor Components
	 */
    reg [7:0] GHR;  // 8-bit Global History Register
    reg [1:0] PHT[255:0];  // 256-entry Pattern History Table, each with a 2-bit saturating counter

    wire [7:0] pht_index;
    wire [1:0] current_prediction;

    /*
     *  Calculate PHT index using XOR of GHR and lower bits of in_addr
     */
    assign pht_index = GHR ^ in_addr[7:0];

    /*
     *  Calculate branch address using combinational logic
     */
    assign branch_addr = in_addr + offset;

    /*
     *  Access current prediction from PHT
     */
    always @(posedge clk) begin
        if (reset) begin
            GHR <= 8'b0;
            prediction <= 0;
        end 
        else begin
            prediction <= PHT[pht_index][1] & branch_decode_sig;
        end
	end

	/*
     *  Update GHR and PHT based on actual branch decision
     */
    always @(negedge clk) begin
        if (branch_mem_sig) begin
            // Update the GHR
            GHR <= {GHR[6:0], actual_branch_decision};

            // Update the PHT: simple saturating counter logic
            if (actual_branch_decision) begin
                if (PHT[pht_index] != 2'b11)
                    PHT[pht_index] <= PHT[pht_index] + 1;
            end else begin
                if (PHT[pht_index] != 2'b00)
                    PHT[pht_index] <= PHT[pht_index] - 1;
            end
		end
	end

endmodule
