
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

SB_RAM40_4K #(
    .INIT_0(256'h00000000000000000000000000000000000000000000000000000000_44_33_22_11),
    .WRITE_MODE(1),
    .READ_MODE(1)
) ram40_4k_512x8 (
    .RCLK(clock),
    .RCLKE(perform_read),
    .RE(perform_read),
    .RADDR(read_address),
    .RDATA(read_data),
    .WE(perform_write),
    .WCLK(clock),
    .WCLKE(perform_write),
    .WADDR(write_address),
    .WDATA(write_data)
);

// Assume, data from the RAM is available at the next clock
always @(posedge clock) read_data_ready <= perform_read;

endmodule

`endif
