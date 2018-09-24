
`include "clock_generator.v"
`include "led_selector.v"
`include "memory.v"
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
wire bit_segment_clock, bit_clock, led_clock, framerate;

clock_generator clocks(
    .clock_12mhz(clock_12mhz),
    .bit_segment_clock(bit_segment_clock),
    .bit_clock(bit_clock),
    .led_clock(led_clock),
    .framerate(framerate)
    );

/** Select the next LED to be transmitted */
wire encoder_done;
wire perform_read;
wire[7:0] led_counter;

led_selector selector(
    .clock_12mhz(clock_12mhz),
    .led_clock(led_clock),
    .framerate(framerate),
    .led_counter(led_counter),
    .led_selected(perform_read)
    );

/** Memory to store the LED values */
wire[7:0] strip0_data;
wire encoder_start;

memory ram0(
    .clock(clock_12mhz),
    .perform_read(led_selector_done),
    .read_address({1'b0, led_counter}),
    .read_data(strip0_data),
    .read_data_ready(encoder_start)
    );

/** Generate control signals for an LED strip */
wire _strip0_data = {16'b0, strip0_data};

encoder_xx6812 strip0(
    .clock_3mhz(bit_segment_clock),
    .counter_reset(encoder_start),
    .parallel_data_in(_strip0_data),
    .serial_data_out(strip),
    .done(encoder_done)
    );

endmodule
