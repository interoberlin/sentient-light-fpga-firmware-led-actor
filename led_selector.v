/**
 * This module selects, which LED's data
 * is to be transmitted next.
 */

`ifndef LED_SELECTOR_V
`define LED_SELECTOR_V

module led_selector(
    input clock_12mhz,
    input led_clock,
    input framerate,
    output reg[7:0] led_counter,
    output reg led_selected,
    output reg done
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
 * LED counter
 */
wire led_counter_enabled = ~framerate;
reg _done;

always @(posedge led_clock or posedge led_counter_reset)
begin
    if (led_counter_reset)
    begin
        led_counter <= 149;
        _done <= 0;
    end
    else begin
        if (led_counter_enabled && (led_counter > 0))
        begin
            led_counter <= led_counter - 1;
        end

        if (led_counter == 0)
            _done <= 1;
    end
end

/*
 * When done, only output a pulse,
 * the done signal should not remain high
 */
reg previous_done;

always @(posedge clock_12mhz)
begin
    previous_done <= done;
    done <= (_done && (~previous_done));
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

endmodule

`endif
