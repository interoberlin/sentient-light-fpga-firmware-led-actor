
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

reg[7:0] led_counter;
initial led_counter <= 0;

reg led_counter_reset;
initial led_counter_reset <= 1;

always @(posedge led_clock or posedge led_counter_reset)
begin
    if (led_counter_reset)
    begin
        led_counter <= 0;
        led_clock_enabled <= 1;
    end
    else begin
        if (led_counter == 150)
            led_clock_enabled <= 0;
        else
            led_counter <= led_counter + 1;
    end
end

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


reg previous_framerate;

always @(posedge clock_12mhz)
begin
    previous_framerate <= framerate;
    led_counter_reset <= (framerate && (previous_framerate != framerate));
end


reg previous_led_clock;

always @(posedge clock_12mhz)
begin
    previous_led_clock <= led_clock;
    encoder_reset <= (led_clock && (previous_led_clock != led_clock));
end

endmodule

`endif
