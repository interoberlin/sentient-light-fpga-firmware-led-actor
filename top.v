
`include "clock_generator.v"
`include "encoder_xx6812.v"

module top(
    input clock_12mhz,

    output clock_out,

    output bit_segment_clock,
    output bit_clock,
    output led_clock,
    output framerate,

    output strip
    );

assign clock_out = clock_12mhz;

/** Begin transmitting a frame at the rising edge of this clock */
// wire bit_segment_clock, bit_clock, led_clock, framerate;

/** Generate all the clocks for this system */
clock_generator clocks(
    .clock_12mhz(clock_12mhz),
    .bit_segment_clock(bit_segment_clock),
    .bit_clock(bit_clock),
    .led_clock(led_clock),
    .framerate(framerate)
    );

reg[23:0] strip0_data = 24'b0;

/** Memory to store the LED values */
// ram mem0(
//
//     );

/** Generate control signals for an LED strip */
encoder_xx6812 strip0(
    .clock(bit_segment_clock),
    .reset(encoder_reset),
    .parallel_data_in(strip0_data),
    .serial_data_out(strip)
    );

endmodule
