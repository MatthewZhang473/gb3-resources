module cache (
    input clk,
    input reset,
    input memwrite,
    input memread,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data,
    output reg hit,
    output reg miss
);

    parameter CACHE_SIZE = 16;  // Define cache size
    parameter TAG_WIDTH = 26;   // Define tag width = Total address bits (usually 32) - INDEX_WIDTH - OFFSET_WIDTH.
    parameter INDEX_WIDTH = 4;  // Define index width  = log2(CACHE_SIZE).
    parameter OFFSET_WIDTH = 2; // Define block offset width = log2(block size), where block size = 2^OFFSET_WIDTH.

    reg [31:0] cache_data [0:CACHE_SIZE-1];  // Cache data storage
    reg [TAG_WIDTH-1:0] tags [0:CACHE_SIZE-1]; // Cache tag storage
    reg valid [0:CACHE_SIZE-1];  // Valid bits storage

    wire [INDEX_WIDTH-1:0] index;
    wire [OFFSET_WIDTH-1:0] offset;
    wire [TAG_WIDTH-1:0] tag;

    assign index = addr[INDEX_WIDTH+OFFSET_WIDTH-1:OFFSET_WIDTH];
    assign offset = addr[OFFSET_WIDTH-1:0];
    assign tag = addr[31:INDEX_WIDTH+OFFSET_WIDTH];

    integer i;  // Declare loop variable as integer

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < CACHE_SIZE; i = i + 1) begin
                valid[i] <= 1'b0;
            end
            hit <= 1'b0;
            miss <= 1'b0;
        end else begin
            if (memread) begin
                if (valid[index] && tags[index] == tag) begin
                    read_data <= cache_data[index];
                    hit <= 1'b1;
                    miss <= 1'b0;
                end else begin
                    hit <= 1'b0;
                    miss <= 1'b1;
                end
            end
            if (memwrite) begin
                cache_data[index] <= write_data;
                tags[index] <= tag;
                valid[index] <= 1'b1;
                hit <= 1'b0;
                miss <= 1'b0;
            end
        end
    end

endmodule
