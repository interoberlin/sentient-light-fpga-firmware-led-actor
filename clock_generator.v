
`ifndef CLOCK_GENERATOR_V
`define CLOCK_GENERATOR_V

// `include "pll_144mhz.v"

module clock_generator(
    input clock_12mhz,
    input clock_144mhz,
    output reg clock_115200hz,
    input uart_rx,
    output reg bit_segment_clock,
    output reg bit_clock,
    output reg led_clock,
    output reg encoder_reset,
    output reg framerate
    );

/*
 * The UART clock can/should be synchronized to the incoming data
 * in order to make sure, the data bit sample point lies
 * ideally in the middle of the bit.
 * Sampling happens at the rising edge of clock_115200hz,
 * therefore at a level change on the RX pin
 * the counter should reset in a way,
 * that the next rising edge of the clock occurs in half a bit.
 */
reg previous_rx = 0;
reg rx_sync = 0;
always @(posedge clock_144mhz)
begin
    previous_rx <= uart_rx;

    if (previous_rx != uart_rx)
        rx_sync <= 1;
    else
        rx_sync <= 0;
end

/*
 * Divide clock back down to 115200
 */
reg[10:0] clock_115200hz_counter;

always @(posedge clock_144mhz)
begin
    if (rx_sync)
    begin
        clock_115200hz_counter <= 0;
        clock_115200hz <= 0;
    end
    else begin
        clock_115200hz_counter <= clock_115200hz_counter + 1;

        if (clock_115200hz_counter < 624)
        begin
            clock_115200hz <= 0;
        end
        else begin
            clock_115200hz <= 1;
        end

        if (clock_115200hz_counter == 1248)
        begin
            clock_115200hz_counter <= 0;
            clock_115200hz <= 0;
        end
    end
end

/*
 * Generate the clocks for shifting out the bits
 */

initial bit_segment_clock <= 0;
initial bit_clock <= 0;
initial led_clock <= 0;
initial framerate <= 0;

reg divisor1;
initial divisor1 <= 0;

always @(posedge clock_12mhz)
begin
    // 6 MHz
    divisor1 <= ~divisor1;
    if (divisor1)
    begin
        // 3 MHz
        bit_segment_clock <= ~bit_segment_clock;
    end
end

reg divisor3;
initial divisor3 <= 0;

always @(posedge bit_segment_clock)
begin
    // 1.5 MHz
    divisor3 <= ~divisor3;
    if (divisor3)
    begin
        // 750 kHz
        bit_clock <= ~bit_clock;
    end
end

reg[3:0] bit_counter;
initial bit_counter <= 0;

reg led_clock_enabled;
initial led_clock_enabled <= 1;

always @(posedge bit_clock)
begin
    if (bit_counter == 0)
    begin
        if (led_clock_enabled)
            led_clock <= ~led_clock;
    end
    bit_counter <= bit_counter + 1;
end

/*
 * Generate a 60 Hz signal
 */
reg[17:0] framerate_counter;
initial framerate_counter <= 0;

always @(posedge clock_12mhz)
begin
    // if (framerate_counter == 100000)
    if (framerate_counter == 99999)
    begin
        // 60 Hz
        framerate <= ~framerate;
        framerate_counter <= 0;
    end
    else begin
        framerate_counter <= framerate_counter + 1;
    end
end

endmodule

`endif
