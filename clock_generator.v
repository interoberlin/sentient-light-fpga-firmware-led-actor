
`ifndef CLOCK_GENERATOR_V
`define CLOCK_GENERATOR_V

module clock_generator(
    input clock_12mhz,
    output reg bit_segment_clock,
    output reg bit_clock,
    output reg led_clock,
    output reg encoder_reset,
    output reg framerate
    );

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
    if (framerate_counter == 100000)
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
