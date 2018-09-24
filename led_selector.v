/**
 * This module selects, which LED's data
 * is to be transmitted next.
 */

`ifndef LED_SELECTOR_V
`define LED_SELECTOR_V

module led_selector(
    input led_clock,
    input led_counter_enabled,
    input led_counter_reset,
    output reg[7:0] led_counter,
    output reg done
    );

always @(posedge led_clock or posedge led_counter_reset)
begin
    if (led_counter_reset)
    begin
        led_counter <= 149;
        done <= 0;
    end
    else begin
        if (led_counter_enabled && (led_counter > 0))
        begin
            led_counter <= led_counter - 1;
        end

        if (led_counter == 0)
            done <= 1;
    end
end

endmodule

`endif
