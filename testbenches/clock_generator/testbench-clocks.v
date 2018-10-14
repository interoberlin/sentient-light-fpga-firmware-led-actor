`timescale 1ns/1ns

`include "../../clock_generator.v"

module test;

initial $dumpvars;

reg clock_144mhz;
reg clock_12mhz;
reg reset;

initial clock_144mhz <= 0;
initial clock_12mhz <= 0;
always #1 clock_144mhz <= ~clock_144mhz;
always #12 clock_12mhz <= ~clock_12mhz;

// End of test signal generation
initial #24000 $finish;

/*
 * Test the synchronization of the 115200 Hz clock
 * to the UART RX signal
 */
reg uart_rx;
initial uart_rx <= 0;
initial #500 uart_rx <= 1;

/** Module under test */
wire bit_segment_clock, bit_clock, led_clock, framerate;

clock_generator clocks(
    .clock_144mhz(clock_144mhz),
    .clock_12mhz(clock_12mhz),
    .bit_segment_clock(bit_segment_clock),
    .bit_clock(bit_clock),
    .led_clock(led_clock),
    .framerate(framerate),
    .uart_rx(uart_rx)
    );

endmodule
