
`ifndef MEMORY_V
`define MEMORY_V

module memory(
    input clock,

    input perform_read,
    input [8:0] read_address,
    output reg[7:0] read_data,
    output reg read_data_ready,

    input perform_write,
    input [8:0] write_data,
    input [7:0] write_address
    );

// Dual-ported RAM block, see also Silicon Blue iCE40 Technology Library
reg[7:0] mem[0:511];

always @(posedge clock)
begin
    // Read
    if (perform_read)
        read_data <= mem[read_address];
    // Write
    if (perform_write)
        mem[write_address] <= write_data;
end

// Assume, data from the RAM is available at the next clock
always @(posedge clock) read_data_ready <= perform_read;

endmodule

`endif
