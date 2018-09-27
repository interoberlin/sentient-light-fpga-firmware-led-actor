
`include "clock_generator.v"
`include "uart.v"
`include "led_selector.v"
`include "memory.v"
`include "encoder_xx6812.v"


module top(
    input clock_12mhz,

    output clock_out,
    output clock_144mhz,

    input uart_rx,
    output uart_debug,

    output bit_segment_clock,
    output bit_clock,
    output led_clock,
    output framerate,
    output clock_115200hz,
    output perform_read,
    output led_counter_clock,
    output led_counter_reset,

    output strip,

    output[7:0] led
    );

/** Verify UART input */
assign uart_debug = uart_rx;

/** Verify that the primary clock is working */
assign clock_out = clock_12mhz;

/** Generate all the clocks for this system */
wire clock_115200hz, bit_segment_clock, bit_clock, led_clock, framerate;

clock_generator clocks(
    .clock_12mhz(clock_12mhz),
    .clock_144mhz(clock_144mhz),
    .clock_115200hz(clock_115200hz),
    .bit_segment_clock(bit_segment_clock),
    .bit_clock(bit_clock),
    .led_clock(led_clock),
    .framerate(framerate)
    );

wire[7:0] uart_rx_data;
assign led[7:0] = uart_rx_data[7:0];
wire uart_rx_data_ready;

uart uart0(
    .clock_115200hz(clock_115200hz),
    .reset(1'b0),
    .rx(uart_rx),
    .rx_data(uart_rx_data),
    .rx_data_ready(uart_rx_data_ready)
    );

/** Select the next LED to be transmitted */
wire encoder_finished;
// wire perform_read;
wire[7:0] led_counter;

led_selector selector(
    .clock_12mhz(clock_12mhz),
    .bit_clock(bit_clock),
    .led_clock(led_clock),
    .framerate(framerate),
    .encoder_finished(encoder_finished),
    .led_counter_clock(led_counter_clock),
    .led_counter_reset(led_counter_reset),
    .led_counter(led_counter),
    .led_selected(perform_read)
    );

/** Memory to store the LED values */
wire[23:0] strip0_data;
wire encoder_start;

memory ram0(
    .clock(clock_12mhz),
    .perform_read(perform_read),
    .read_address({1'b0, led_counter}),
    .read_data(strip0_data),
    .read_data_ready(encoder_start),
    // Holding perform_write low is obligatory, if the write port is not used, otherwise memory content may be overwritten.
    .perform_write(uart_rx_data_ready),
    .write_address(8'b0),
    .write_data(uart_rx_data)
    );

encoder_xx6812 strip0(
    .clock_3mhz(bit_segment_clock),
    .counter_reset(encoder_start),
    .parallel_data_in(strip0_data),
    .serial_data_out(strip),
    .done(encoder_finished)
    );

endmodule
