module branch_predictor(
        clk,
        actual_branch_decision,
        branch_decode_sig,
        branch_mem_sig,
        in_addr,
        offset,
        branch_addr,
        prediction
    );

    /*
     *  inputs
     */
    input        clk;
    input        actual_branch_decision;
    input        branch_decode_sig;
    input        branch_mem_sig;
    input [31:0] in_addr;
    input [31:0] offset;

    /*
     *  outputs
     */
    output wire [31:0] branch_addr;  // Use wire for combinational logic
    output reg        prediction;

    /*
     *  Gshare Predictor Components
     */
    reg [7:0] GHR;  // 8-bit Global History Register
    reg [1:0] PHT[255:0];  // 256-entry Pattern History Table, each with a 2-bit saturating counter

    wire [7:0] pht_index;
    
    /*
     *  Initial block to initialize PHT to weakly not taken state
     *  Note: The initial block is synthesizable in some FPGAs and ASICs but not in all.
     *  Ensure your synthesis tool supports it or use another method for initialization.
     */
    integer i;
    initial begin
        GHR = 8'b0;
        for (i = 0; i < 256; i = i + 1) begin
            PHT[i] = 2'b01;  // Initialize PHT to weakly not taken state
        end
    end


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
        prediction <= PHT[pht_index][1] & branch_decode_sig;
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
