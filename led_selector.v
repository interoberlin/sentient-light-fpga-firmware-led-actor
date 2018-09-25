/**
 * This module selects, which LED's data
 * is to be transmitted next.
 */

`ifndef LED_SELECTOR_V
`define LED_SELECTOR_V

module led_selector(
    input clock_12mhz,
    input bit_clock,
    input led_clock,
    input framerate,
    input encoder_finished,
    output led_counter_clock,
    output reg led_counter_reset,
    output reg[7:0] led_counter,
    output reg led_selected,
    output reg done
    );

/*
 * Generate a reset pulse for the LED counter
 * at the falling edge of the framerate (60 Hz) signal
 */
// reg led_counter_reset;
reg previous_framerate;

always @(posedge clock_12mhz)
begin
    previous_framerate <= framerate;
    led_counter_reset <= (framerate && (~previous_framerate));
end

/*
 * Generate a clock for the LED counter
 */
reg previous_encoder_finished;
reg previous_led_clock;
// reg led_counter_clock;

assign led_counter_clock = led_clock;

// always @(posedge bit_clock)
// begin
//     previous_encoder_finished <= encoder_finished;
//     previous_led_clock <= led_clock;
    // led_counter_clock <= (encoder_finished && (~previous_encoder_finished));
     // || (led_clock && (~previous_led_clock));
// end

/*
 * LED counter
 */
reg _done;
reg _led_selected;

always @(posedge led_counter_clock or posedge led_counter_reset)
begin
    if (led_counter_reset)
    begin
        led_counter <= 149;
        _done <= 0;
    end
    else begin
        if (led_counter == 0)
        begin
            _done <= 1;
        end
        else begin
            led_counter <= led_counter - 1;
            _led_selected <= ~_led_selected;
        end
    end
end

/*
 * Generate a pulse to notify subsequent modules,
 * that we have selected a new LED
 */
reg previous_led_selected;

always @(posedge clock_12mhz)
begin
    previous_led_selected <= _led_selected;
    led_selected <= (previous_led_selected && ~_led_selected) || (~previous_led_selected && _led_selected);
    // led_selected <= _led_selected;
end

/*
 * When done, only output a pulse,
 * the done signal should not remain high
 */
reg previous_done;

always @(posedge clock_12mhz)
begin
    previous_done <= _done;
    done <= (_done && (~previous_done));
end

endmodule

`endif
