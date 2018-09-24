
`ifndef SIGNAL_GENERATOR_V
`define SIGNAL_GENERATOR_V

module signal_generator(
    input clock_12mhz,
    input led_clock,
    input framerate,

    /** This signal is high at the rising edge of led_clock and otherwise low */
    output reg led_clock_rising_edge,

    /** Signal the LED selector to begin iterating through all LEDs */
    output led_counter_reset,

    /** Signal the xx6812 encoder to start transmitting */
    output reg encoder_start
    );

/*
 * Generate a reset pulse for the LED counter
 * at the falling edge of the framerate (60 Hz) signal
 */
reg led_counter_reset;
reg previous_framerate;
always @(negedge framerate)
begin
    previous_framerate <= framerate;
    led_counter_reset <= (~framerate) && previous_framerate;
end

/*
 * Generate a start i.e. reset pulse for the xx6812 encoder
 * signalling it to start transmission of 24 bits
 *
 * This pulse is delayed against the rising edge of led_clock
 * by 4 clock ticks in order to allow for the RAM block to
 * have the requested data ready at it's outputs.
 */
reg previous_led_clock;

always @(posedge clock_12mhz)
begin
    previous_led_clock <= led_clock;
    led_clock_rising_edge <= (led_clock && ~previous_led_clock);
end

reg[1:0] delay_counter;
always @(posedge clock_12mhz or posedge led_clock_rising_edge)
begin
    if (led_clock_rising_edge)
    begin
        delay_counter <= 0;
        encoder_start <= 0;
    end
    else begin
        if (delay_counter == 3)
        begin
            encoder_start <= 1;
        end
        else begin
            delay_counter <= delay_counter + 1;
            encoder_start <= 0;
        end
    end
end

endmodule

`endif
