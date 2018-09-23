
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


// reg[23:0] strip0_data = 24'b111111111111111111111111;
reg[23:0] strip0_data = 24'b100000001000000010000000;

reg encoder_reset;
reg previous_led_clock;
always @(posedge clock_12mhz)
begin
    previous_led_clock <= led_clock;
    encoder_reset <= (led_clock && (previous_led_clock != led_clock));
end

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
