
`include "clock_generator.v"
`include "signal_generator.v"
`include "led_selector.v"
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

/** Verify that the primary clock is working */
assign clock_out = clock_12mhz;

/** Generate all the clocks for this system */
clock_generator clocks(
    .clock_12mhz(clock_12mhz),
    .bit_segment_clock(bit_segment_clock),
    .bit_clock(bit_clock),
    .led_clock(led_clock),
    .framerate(framerate)
    );

/** Generate the timing for this system */
signal_generator signals(
    .led_counter_reset(led_counter_reset),
    .encoder_start(encoder_start)
    );

/** Select the next LED to be transmitted */
led_selector selector(
    .led_clock(led_clock),
    .led_counter_enabled(~framerate),
    .led_counter_reset(led_counter_reset)
    );

// reg[23:0] strip0_data = 24'b111111111111111111111111;
reg[23:0] strip0_data = 24'b100000001000000010000000;

/** Memory to store the LED values */
// ram mem0(
//
//     );

/** Generate control signals for an LED strip */
encoder_xx6812 strip0(
    .clock_3mhz(bit_segment_clock),
    .counter_reset(encoder_start),
    .parallel_data_in(strip0_data),
    .serial_data_out(strip)
    );

endmodule
