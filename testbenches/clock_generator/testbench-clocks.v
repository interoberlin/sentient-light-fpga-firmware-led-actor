`timescale 1ns/1ns

`include "../../clock_generator.v"

module test;

initial $dumpvars;

reg clock_12mhz, reset;

initial clock_12mhz <= 0;
always #1 clock_12mhz <= ~clock_12mhz;


// End of test signal generation
initial #2000 $finish;


/** Module under test */
wire bit_segment_clock, bit_clock, led_clock, framerate;

clock_generator clocks(
    .clock_12mhz(clock_12mhz),
    .bit_segment_clock(bit_segment_clock),
    .bit_clock(bit_clock),
    .led_clock(led_clock),
    .framerate(framerate)
    );

endmodule
